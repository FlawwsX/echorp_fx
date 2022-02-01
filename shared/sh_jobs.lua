print(('%sLoaded shared/jobs module!'):format(FRAMEWORK.DebugPrint))

FRAMEWORK.JOBS = {

	JobList = {
		['unemployed'] = {
			label = 'Unemployed',
			grades = { [1] = { label = 'Unemployed', moneys = 0, owner = 0 } },
		},
		['ambulance'] = {
			label = 'Mount Zonah',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-447.16, -353.64, 24.22), vector3(-471.09, -364.96, 24.22), vector3(-425.34, -343.32, 24.22), vector3(-447.32, -318.69, 78.16), vector3(1822.88, 3666.58, 34.27), vector3(-265.32, 6330.29, 32.41)}
		},
		['bennys'] = {
			label = 'Bennys',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vec3(-227.51, -1327.42, 30.89)}
		},
		['doj'] = {
			label = 'Department of Justice',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(241.25, -1100.43, 36.12)}
		},
		['flywheels'] = {
			label = 'Carbon N\' Chrome',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-1417.24, -446.16, 35.9)}
		},
		['flywheels2'] = {
			label = 'Carbon N\' Chrome Harmony',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(1178.39, 2655.35, 37.87)}
		},
		['garbage'] = {
			label = 'Garbage Collection',
			business = false,
			grades = {},
			hasGarage = false,
			locations = {}
		},
		['gopostal'] = {
			label = 'Go Postal',
			business = false,
			grades = {},
			hasGarage = false,
			locations = {}
		},
		['jt3nv7'] = {
			label = 'Auto Exotic',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(912.82, -967.81, 39.49)}
		},
		['lostmc'] = {
			label = 'LostMC',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(998.68, -124.25, 74.06)}
		},
		['lumberjack'] = {
			label = 'Lumberjack',
			business = false,
			grades = {},
			hasGarage = false,
			locations = {}
		},
		['miner'] = {
			label = 'Miner',
			business = false,
			grades = {},
			hasGarage = false,
			locations = {}
		},
		['construction'] = {
			label = 'Construction',
			business = false,
			grades = { [1] = { label = 'Employee', moneys = 50, owner = 0 } },
			hasGarage = false,
			locations = {}
		},
		['banker'] = {
			label = 'Banker',
			business = false,
			grades = { [1] = { label = 'Employee', moneys = 50, owner = 0 } },
			hasGarage = false,
			locations = {}
		},
		['pdm'] = {
			label = 'Luxury Autos',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-33.53, -1102.09, 26.42)}
		},
		['pizzaboy'] = {
			label = 'Pizza Boy',
			business = false,
			grades = {},
			hasGarage = false,
			locations = {}
		},
		['realestate'] = {
			label = 'Dynasty 8',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-104.87, -610.17, 36.07), vector3(-155.45, -593.59, 32.41)}
		},
		['taco'] = {
			label = 'Taco',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(11.53, -1599.48, 29.30)}
		},
		['taxi'] = {
			label = 'Taxi',
			business = false,
			grades = {},
			hasGarage = true,
			locations = {vector3(913.73, -166.46, 74.32)}
		},
		['trucker'] = {
			label = 'Trucker',
			business = false,
			grades = {},
			hasGarage = false,
			locations = {}
		},
		['vanilla'] = {
			label = 'Vanilla Unicorn',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(129.9, -1284.36, 29.26)}
		},
		['pa'] = {
			label = 'Public Affairs',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(444.55, -999.47, 25.91), vector3(1868.1, 3686.14, 33.78), vector3(1736.69, 2578.54, 61.68), vector3(1644.01, 2603.21, 45.56), vector3(1835.35, 2506.01, 47.56), vector3(1833.44, 2541.96, 45.88), vector3(-467.31, 6022.77, 31.34), vector3(380.8, -1626.54, 29.28)}
		},
		['weazelnews'] = {
			label = 'Weazel News',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-616.0, -924.15, 23.08), vector3(-557.74, -931.71, 23.85)}
		},
		['potato'] = {
			label = 'TopHat Potatoes',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-90.49, 1886.89, 197.32)}
		},
		['cdmortuary'] = {
			label = 'Cloudy Days Mortuary',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(262.54, -1378.58, 39.52)}
		},
		['gatsnstraps'] = {
			label = 'Chi Chi\'s L&L',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(1689.485, 3757.688, 34.70532), vector3(-6.814613, -1109.773, 28.74855)}
		},
		['citywork'] = {
			label = 'LS Water & Power',
			business = false,
			grades = { [1] = { label = 'Employee', moneys = 50, owner = 0 } },
			hasGarage = false,
			locations = {}
		},
		['mecca'] = {
			label = 'Mecca Scrapyard',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(241.25, -1100.43, 36.12)}
		},

		['lspd'] = {
			label = 'LSPD',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(444.55, -999.47, 25.91), vector3(1868.1, 3686.14, 33.78), vector3(478.085, -1022.866, 28.03562), vector3(1736.69, 2578.54, 61.68), vector3(1644.01, 2603.21, 45.56), vector3(1835.35, 2506.01, 47.56), vector3(1833.44, 2541.96, 45.88), vector3(-475.16, 5989.21, 31.34), vector3(-467.31, 6022.77, 31.34), vector3(380.8, -1626.54, 29.28)}
		},
		['bcso'] = {
			label = 'BCSO',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(444.55, -999.47, 25.91), vector3(1868.1, 3686.14, 33.78), vector3(478.085, -1022.866, 28.03562), vector3(1736.69, 2578.54, 61.68), vector3(1644.01, 2603.21, 45.56), vector3(1835.35, 2506.01, 47.56), vector3(1833.44, 2541.96, 45.88), vector3(-475.16, 5989.21, 31.34), vector3(-467.31, 6022.77, 31.34), vector3(380.8, -1626.54, 29.28)}
		},
		['sast'] = {
			label = 'SASP',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(444.55, -999.47, 25.91), vector3(1868.1, 3686.14, 33.78), vector3(478.085, -1022.866, 28.03562), vector3(1736.69, 2578.54, 61.68), vector3(1644.01, 2603.21, 45.56), vector3(1835.35, 2506.01, 47.56), vector3(1833.44, 2541.96, 45.88), vector3(-475.16, 5989.21, 31.34), vector3(-467.31, 6022.77, 31.34), vector3(380.8, -1626.54, 29.28)}
		},
		['sasp'] = {
			label = 'SASP',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(444.55, -999.47, 25.91), vector3(1868.1, 3686.14, 33.78), vector3(478.085, -1022.866, 28.03562), vector3(1736.69, 2578.54, 61.68), vector3(1644.01, 2603.21, 45.56), vector3(1835.35, 2506.01, 47.56), vector3(1833.44, 2541.96, 45.88), vector3(-475.16, 5989.21, 31.34), vector3(-467.31, 6022.77, 31.34), vector3(380.8, -1626.54, 29.28)}
		},
		['doc'] = {
			label = 'DOC',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(444.55, -999.47, 25.91), vector3(1868.1, 3686.14, 33.78), vector3(478.085, -1022.866, 28.03562), vector3(1736.69, 2578.54, 61.68), vector3(1644.01, 2603.21, 45.56), vector3(1835.35, 2506.01, 47.56), vector3(1833.44, 2541.96, 45.88), vector3(-475.16, 5989.21, 31.34), vector3(-467.31, 6022.77, 31.34), vector3(380.8, -1626.54, 29.28)}
		},
		['sapr'] = {
			label = 'SAPR',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(444.55, -999.47, 25.91), vector3(1868.1, 3686.14, 33.78), vector3(478.085, -1022.866, 28.03562), vector3(1736.69, 2578.54, 61.68), vector3(1644.01, 2603.21, 45.56), vector3(1835.35, 2506.01, 47.56), vector3(1833.44, 2541.96, 45.88), vector3(-475.16, 5989.21, 31.34), vector3(-467.31, 6022.77, 31.34), vector3(380.8, -1626.54, 29.28)}
		},

		['driftclub'] = {
			label = 'Drift Club',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {}
		},
		['legacyrecords'] = {
			label = 'Legacy Records',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-1387.54, -608.95, 30.31), vector3(195.4, -11.53, 69.89)}
		},
		['luxurytransportation'] = {
			label = 'Luxury Transportation',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(913.73, -166.46, 74.32), vector3(934.55, -1.9, 78.75)}
		},
		['pegasusairlines'] = {
			label = 'Pegasus Airlines',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-1655.78, -3149.68, 13.98)}
		},
		['casino'] = {
			label = 'Diamond Casino',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(934.55, -1.9, 78.75)}
		},
		['committee'] = {
			label = 'State Committee',
			business = true,
			grades = {},
			hasGarage = false,
			locations = {}
		},
		['legacym'] = {
			label = 'Legacy',
			business = true,
			grades = { [1] = { label = 'Cool Singer', moneys = 250, owner = 0 } },
			hasGarage = true,
			locations = {vector3(444.55, -999.47, 25.91), vector3(1868.1, 3686.14, 33.78)}
		},
		['thc'] = {
			label = 'Thorhall\'s Holistic Center',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(377.748, -828.7451, 29.3025)}
		},
		['f1'] = {
			label = 'F1',
			business = true,
			grades = { [1] = { label = 'Employee', moneys = 0, owner = 0 } },
			hasGarage = true,
			locations = {vector3(946.25, -2356.04, 21.21)}
		},
		['soochi'] = {
			label = 'SooChi',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-1839.9, -1214.47, 13.0)}
		},
		['levelup'] = {
			label = 'Level Up Lounge',
			business = true,
			grades = { [1] = {owner = 1} },
			hasGarage = true,
			locations = {vector3(334.64, -914.1, 29.25)}
		},
		['bikesrus'] = {
			label = 'Bikes R Us',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-64.72324, 70.01147, 71.87317)}
		},
		['driftschool'] = {
			label = 'Drift School',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(977.06, -2358.83, 21.21)}
		},
		['sidewaysu'] = {
			label = 'Sideways University',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(144.17, -3021.16, 7.04)}
		},
		['sagma'] = {
			label = 'San Andreas Gallery of Modern Art',
			business = true,
			grades = { [1] = {owner = 1} },
			hasGarage = true,
			locations = {vector3(-511.31, 51.89, 52.57)}
		},
		['petshop'] = {
			label = 'Pet Shop',
			business = true,
			grades = { [1] = {owner = 1} },
			hasGarage = false,
			locations = {}
		},
		['biteme'] = {
			label = 'Bite Me Café',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-1181.83, -1128.24, 5.69)}
		},
		['momentz'] = {
			label = 'Momentz Photography',
			business = true,
			grades = {},
			hasGarage = false,
			locations = {}
		},
		['empire'] = {
			label = 'Empire Imports',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-43.31, -1095.45, 27.26)}
		},
		['burgershot'] = {
			label = 'Burgershot',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-1164.3492, -889.3510, 14.1394)}
		},
		['marlowevineyard'] = {
			label = 'Marlowe Vineyard',
			business = true,
			grades = {},
			hasGarage = true,
			locations = {vector3(-1920.0, 2048.49, 140.72)}
		},
	},

	LoadJobs = function(self)

		exports.oxmysql:execute('SELECT `id`, `name` FROM `businesses`', {}, function(data)

			local function BusinessInSQL(name)
				for i=1, #data do
					if data[i]['name'] == name then return tonumber(data[i]['id']) end 
				end 
				return -1
			end

			for k,v in pairs(self.JobList) do
				if v.business then
					local businessId = BusinessInSQL(k)
					if not (businessId > 0) then
						exports.oxmysql:insert("INSERT INTO businesses (`name`) VALUES (:name)", { name = k }, function(insertId) 
                            if insertId > 0 then
                                v.databaseId = insertId
                                print("[Jobs] Created Business: "..v['label'].." ("..v['dbId']..")")
                            end
                        end) 
					else
						v.databaseId = businessId
					end
					exports.oxmysql:execute('SELECT `id` FROM `jobgrades` WHERE job=:job LIMIT 1', { job = k }, function(result)
						if #result == 0 then
							exports.oxmysql:insertSync("INSERT INTO jobgrades (`job`, `grade`, `label`, `owner`) VALUES (:job, :grade, :label, :owner)", { job = k, grade = 1, label = 'Owner', owner = 1 })
						end
					end)
				end
			end

		end)

		exports.oxmysql:execute('SELECT `id`, `job`, `grade`, `label`, `money`, `owner` FROM `jobgrades`', {}, function(result)
            for i=1, #result do
                if result[i] then
                    local data = result[i]
                    if self.JobList[data['job']] then
                        self.JobList[data['job']]['grades'][tonumber(data['grade'])] = {
                            databaseId = data['id'],
                            label = data['label'],
                            moneys = tonumber(data['money']),
                            owner = data['owner']
                        }
                    end 
                end 
            end
        end)

	end,

	GetJobData = function(self, job)
		return self.JobList[job]
	end

}

CreateThread(function()
	if IsDuplicityVersion() then
		FRAMEWORK.JOBS:LoadJobs()
	end
end)

AddEventHandler('echorp:getJobInfo', function(sentJob, cb)
    cb(FRAMEWORK.JOBS:GetJobData(sentJob))
end)

exports('getJobData', function(...) -- exports['echorp_fx']:getJobData(job)
	return FRAMEWORK.JOBS:GetJobData(...)
end) 

-- The below should be refactored at a later date...

AddEventHandler('echorp:adjustowner', function(job, grade, level, src)
	local gradeInfo = FRAMEWORK.JOBS.JobList[job]['grades'][grade]
	exports.oxmysql:update('UPDATE `jobgrades` SET owner=:owner WHERE id=:id', {owner = tonumber(level), id = gradeInfo['databaseId']}, function(result)
		if result > 0 then
			FRAMEWORK.JOBS.JobList[job]['grades'][grade]['owner'] = tonumber(level)
			local ownerLevel = ""
			if level == 1 then ownerLevel = "Full Access" elseif level == 2 then ownerLevel = "User Management" elseif level == 3 then ownerLevel = "Society Management" end
			if level ~= 0 then TriggerClientEvent('erp_notifications:client:SendAlert', src, { type = 'inform', text = 'Access for '..FRAMEWORK.JOBS.JobList[job]['grades'][grade]['label']..' rank set to '..ownerLevel, length = 5000 })
			else
				TriggerClientEvent('erp_notifications:client:SendAlert', src, { type = 'inform', text = 'All management access removed from '..FRAMEWORK.JOBS.JobList[job]['grades'][grade]['label']..'.', length = 5000 })
			end
		end 
	end) 
end)

AddEventHandler('echorp:adjustsalary', function(job, grade, salary, src)
	local gradeInfo = FRAMEWORK.JOBS.JobList[job]['grades'][grade]
	exports.oxmysql:update('UPDATE `jobgrades` SET money=:money WHERE id=:id', {money = salary, id = gradeInfo['databaseId']}, function(result)
		if result > 0 then
			FRAMEWORK.JOBS.JobList[job]['grades'][grade]['moneys'] = salary
			TriggerClientEvent('erp_notifications:client:SendAlert', src, { type = 'inform', text = 'Salary is now $'..salary, length = 5000 })
		end 
	end) 
end)

AddEventHandler('echorp:adjustname', function(job, grade, newname, src)
	local gradeInfo = FRAMEWORK.JOBS.JobList[job]['grades'][grade]
	exports.oxmysql:update('UPDATE `jobgrades` SET label=:label WHERE id=:id', {label = newname, id = gradeInfo['databaseId']}, function(result)
		if result > 0 then
			FRAMEWORK.JOBS.JobList[job]['grades'][grade]['label'] = newname
			TriggerClientEvent('erp_notifications:client:SendAlert', src, { type = 'inform', text = 'Rank name update to '..newname, length = 5000 })
		end 
	end) 
end)

AddEventHandler('echorp:updatejobgrades', function(job)
	FRAMEWORK.JOBS.JobList[job]['grades'] = {}
	Wait(500)     
	exports.oxmysql:execute('SELECT `id`, `job`, `grade`, `label`, `money`, `owner` FROM `jobgrades` WHERE job=:job', {job = job}, function(result)
		for i=1, #result do
			if result[i] then
				local data = result[i]
				if FRAMEWORK.JOBS.JobList[data['job']] then
					FRAMEWORK.JOBS.JobList[data['job']]['grades'][tonumber(data['grade'])] = {
						databaseId = data['id'],
						label = data['label'],
						moneys = tonumber(data['money']),
						owner = data['owner']
					}
				end 
			end 
		end
	end)
end)