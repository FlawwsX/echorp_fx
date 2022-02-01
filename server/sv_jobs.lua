print(('%sLoaded job module!'):format(FRAMEWORK.DebugPrint))

FRAMEWORK.JOB = {

	UpdateFilter = {
		['set'] = function(self, source, job, grade, cid, currentJob)
			if isOnline then
				local isPolice = FRAMEWORK.MAIN.PoliceJobs[job] or false
				FRAMEWORK.MAIN:UpdatePlayerInfo(source, 'job', {
					name = job,
					grade = grade,
					duty = 1,
					isPolice = isPolice
				})
			end
			exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", { job = job, job_grade = grade, cid = cid })
		end,
		['add'] = function(self, source, job, grade, cid, currentJob)
			exports.oxmysql:execute("SELECT id FROM user_jobs WHERE cid=:cid AND job=:job", {
				cid = cid,
				job = job
			}, function(result)
				if #result > 0 then
					exports.oxmysql:executeSync("UPDATE user_jobs SET job_grade=:job_grade WHERE cid=:cid AND job=:job", {job = job, job_grade = grade, cid = cid})
					if currentJob == job then self.UpdateFilter['set'](source, job, grade, cid, currentJob) end
					return
				end
				print("We passed.")
				exports.oxmysql:executeSync("INSERT INTO `user_jobs` (`cid`, `job`, `job_grade`) VALUES (:cid, :job, :job_grade)", {
					cid = cid,
					job = job,
					job_grade = grade
				})
				exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {
					job = job, 
					job_grade = grade, 
					cid = cid
				})
				self.UpdateFilter['set'](source, job, grade, cid, currentJob)
			end)
		end,
		['remove'] = function(self, source, job, grade, cid, currentJob)
			exports.oxmysql:executeSync("DELETE FROM user_jobs WHERE cid=:cid AND job=:job", {job = job, cid = cid})
			exports.oxmysql:execute("SELECT * FROM user_jobs WHERE cid=:cid", { cid = cid }, function(jobs)
				if #jobs > 0 then
					local isPolice = FRAMEWORK.MAIN.PoliceJobs[jobs[1]['name']] or false
					FRAMEWORK.MAIN:UpdatePlayerInfo(source, 'job', { name = jobs[1]['name'], grade = jobs[1]['job_grade'], duty = 1, isPolice = isPolice })
					exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {job = jobs[1]['name'], job_grade = jobs[1]['job_grade'], cid = cid})
				end
				FRAMEWORK.MAIN:UpdatePlayerInfo(source, 'job', { name = 'unemployed', grade = 1, duty = 1, isPolice = false })
				exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", { job = 'unemployed', job_grade = 1, cid = cid })
			end)
		end
	},

	UpdateJob = function(self, type, job, grade, cid, source)
		
		local grade = tonumber(grade)
		if grade == nil or grade == 0 then 
			grade = 1 
		end

		local playerExists = FRAMEWORK.MAIN:DoesCidExist(cid)
		if not playerExists then return end

		local plyJob = exports.oxmysql:executeSync('SELECT `job`, `job_grade`, `duty` FROM `users` WHERE `id`=:id LIMIT 1', { id = cid })[1]

		if not FRAMEWORK.JOBS.JobList[job] then TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'inform', text = 'Such a job does not exist.', length = 5000 }) return end;
		if not FRAMEWORK.JOBS.JobList[job]['grades'][grade] then return end;

		local jobName = "unemployed"
		if not plyJob then return end;
				
		self.UpdateFilter[type](self, source, job, grade, cid, plyJob.job)

	end,

	Distances = {
		['ambulance'] = { coords = vector3(-475.15, -314.0, 62.15), dist = 100.0, notification = "You must be at Mount Zonah to clock in." }
	},

	DutyDistCheck = function(self, source, job)
		if self.Distances[job] then
			local dist = #( GetEntityCoords(GetPlayerPed(source)) - self.Distances[job]['coords'] )
			return dist <= self.Distances[job]['dist'], self.Distances[job]['notification']
		end
		return true
	end,

	ToggleDuty = function(self, source)

		local player = FRAMEWORK.MAIN:GetPlayerInfo(source, 'source')
		if not player then return end

		local close, notification = self:DutyDistCheck(source, player.job.name)

		if not close then
			TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'error', text = notification, length = 5000 })
			return
		end

		local isPolice = FRAMEWORK.MAIN.PoliceJobs[player.job.name] or false
		local duty = player.job.duty
		if duty == 0 then
			duty = 1
			TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'success', text = 'You are now on duty!', length = 5000 })
			if isPolice then TriggerClientEvent('erp-police:tensixnotice:changeState', player.source, 8) end
		elseif duty == 1 then
			duty = 0
			TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'error', text = 'You are now off duty!', length = 5000 })
			if isPolice then TriggerClientEvent('erp-police:tensixnotice:changeState', player.source, 7) end
		end
		
		FRAMEWORK.MAIN:UpdatePlayerInfo(source, 'job', {
			name = player.job.name,
			grade = player.job.grade,
			duty = duty,
			isPolice = isPolice
		})
		
		exports.oxmysql:executeSync("UPDATE users SET duty=:duty WHERE id=:cid", {duty = duty, cid = player.cid})

	end,

}

RegisterNetEvent('echorp:updatejob', function(type, job, grade, cid, src)
	local src = src or source
	FRAMEWORK.JOB:UpdateJob(type, job, grade, cid, src)
end)

RegisterCommand("addjob", function(source, args, rawCommand)
	if not IsPlayerAceAllowed(source, 'echorp.mod') then return end;
	FRAMEWORK.JOB:UpdateJob("add", args[2], args[3], args[1], source)
end, false)

RegisterCommand("removejob", function(source, args, rawCommand)
	if not IsPlayerAceAllowed(source, 'echorp.mod') then return end;
	FRAMEWORK.JOB:UpdateJob("remove", args[2], 1, args[1], source)
end, false)

AddEventHandler('echorp:toggleduty', function(source)
	FRAMEWORK.JOB:ToggleDuty(source)
end)

RegisterCommand("toggleduty", function(source, args, rawCommand) FRAMEWORK.JOB:ToggleDuty(source) end, false)