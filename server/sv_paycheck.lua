print(('%sLoaded paycheck module!'):format(FRAMEWORK.DebugPrint))

FRAMEWORK.PAYCHECK = {
	
	NewPaycheck = function(self, cid, amount, type, source)

		exports.oxmysql:executeSync('UPDATE `users` SET paycheck = paycheck + :amount WHERE id=:id', { 
			amount = amount, 
			id = cid
		})
		if type == 1 then
			TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'success', text = 'Your UBI check is ready to collect.', length = 5000 } )
		elseif type == 2 then
			TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'success', text = 'Paycheck ($'..amount..') is ready to collect.', length = 5000 } )
		end
		
	end,

	SendPaychecks = function(self)

		local walfareCheck = math.random(50, 75)
		for k,v in pairs(FRAMEWORK.MAIN.Players) do
			if not v.job then return end;

			self:NewPaycheck(v.cid, walfareCheck, 1, v.source)

			if not (v.duty == 1 or v.duty == 2) then return end;
			if not JOBS.JobList[v.job] then return end;

			local gradeInfo = JOBS.JobList[v.job]['grades'][v.grade]
			if not gradeInfo then return end;

			local paycheckAmount = tonumber(gradeInfo.moneys)
			if JOBS.JobList[v.job]['business'] then
				if Guaranteed[job] then self:NewPaycheck(v.cid, paycheckAmount, 2, v.source) return end;
				TriggerEvent('erp_phone:GetMoney', v.job, function(res)
					if res >= pay then
						exports.oxmysql:executeSync("UPDATE businesses SET funds = funds-:pay WHERE name=:name", {pay = paycheckAmount, name = v.job})
						self:NewPaycheck(v.cid, paycheckAmount, 2, v.source)
					else
						TriggerClientEvent('erp_notifications:client:SendAlert', v.source, { type = 'inform', text = 'Your current employee lacks funds pay you this week.', length = 7500 })
					end
				end)
			else
				self:NewPaycheck(v.cid, paycheckAmount, 2, v.source)
			end
		end

		Citizen.SetTimeout(math.random(1350000, 2250000), function() self:SendPaychecks() end) -- 30 mins.

	end,

	NoTaxJobs = {
		['lspd'] = true,
		['bcso'] = true,
		['sast'] = true,
		['sasp'] = true,
		['doc'] = true,
		['sapr'] = true,
		['pa'] = true,
		['ambulance'] = true,
		['doj'] = true,
		['legacyrecords'] = true,
	},

	GetPaycheck = function(self, source)

		local player = FRAMEWORK.MAIN:GetPlayerInfo(source, 'source')
		if not player then return end;

		exports.oxmysql:execute("SELECT paycheck FROM users WHERE id=:id LIMIT 1", {
			id = player.cid
		}, function(res)
			local paycheck = tonumber(res[1]['paycheck'])
			if paycheck <= 0 or not paycheck then TriggerClientEvent('erp_notifications:client:SendAlert', player.source, { type = 'inform', text = 'You have nothing to collect.', length = 5000 }) end
			exports['echorp_fx']:adjustBank(player.cid, paycheck, true, not self.NoTaxJobs[player.job.name])
			TriggerClientEvent('erp_notifications:client:SendAlert', player.source, { type = 'inform', text = 'Paycheck Collected.', length = 5000 })
			exports.oxmysql:executeSync('UPDATE `users` SET paycheck = 0 WHERE id=:id', { id = player.cid })
		end)

	end,

}

Citizen.SetTimeout(math.random(1350000, 2250000), function() FRAMEWORK.PAYCHECK:SendPaychecks() end) -- 5 mins.

RegisterNetEvent('echorp_fx:collectpaycheck', function()
	FRAMEWORK.PAYCHECK:GetPaycheck(source)
end)