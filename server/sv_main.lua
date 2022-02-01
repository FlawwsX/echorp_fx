print(('%sLoaded main module!'):format(FRAMEWORK.DebugPrint))

FRAMEWORK.MAIN = {

	Players = {},
	PlayersCid = {},
	
  	Debug = true,

	PoliceJobs = {
		['lspd'] = true,
		['bcso'] = true,
		['sast'] = true,
		['sasp'] = true,
		['doc'] = true,
		['sapr'] = true,
		['pa'] = true
	},

	SetPlayerBucket = function(self, source, bucket)

		if not source or bucket then return end;

		SetPlayerRoutingBucket(source, bucket)
		SetRoutingBucketPopulationEnabled(bucket, false)
	end,

	HandleJoin = function(self, source)

		if not source then return end;

		local bucket = source * 1000
		local plyPed = GetPlayerPed(source)

		self:SetPlayerBucket(source, bucket)
		FreezeEntityPosition(plyPed, true)
		SetPlayerInvincible(source, true)
		SetEntityCoords(plyPed, vector3(-288.24+math.random(1, 100), -907.95+math.random(1, 100), 676.92+math.random(1, 100)))

		TriggerClientEvent("echorp:spawnInitialized", source)

	end,

	GetIdentifier = function(self, source)
		if not source then return end;
		if self.Players[source] then return self.Players[source]['identifier'] end;
		local numIdentifiers = GetNumPlayerIdentifiers(source)	
		for i=0, numIdentifiers -1 do
			local identifier = GetPlayerIdentifier(source, i)
			if string.find(identifier, "fivem:") then
				return identifier
			end
		end
		return false
	end,

	FetchCharacters = function(self, source)

		if not source then return end;

		local plyCharacters = {}
		local plyIdentifier = self:GetIdentifier(source)
		if not plyIdentifier then DropPlayer(source, 'Missing FiveM identifier') return end;

		local knownCharacters = exports.oxmysql:executeSync("SELECT id, cash, bank, firstname, lastname, dateofbirth, gender FROM users WHERE identifier=:plyIdentifier AND deleted='0'", { 
			plyIdentifier = plyIdentifier 
		})

		for i=1, #knownCharacters do 

			local character = { 
				info = knownCharacters[i], 
				cPed = {} 
			}

			local Skin = exports.oxmysql:executeSync("SELECT model, drawables, props, drawtextures, proptextures FROM character_current WHERE cid = :cid LIMIT 1", { cid = character.info.id })
			if Skin and Skin[1] then
				character['cPed'] = {
					model = Skin[1].model,
					drawables = json.decode(Skin[1].drawables),
					props = json.decode(Skin[1].props),
					drawtextures = json.decode(Skin[1].drawtextures),
					proptextures = json.decode(Skin[1].proptextures),
					tattoos = {}
				}
			end

			local Face = exports.oxmysql:executeSync("SELECT hairColor, headBlend, headOverlay, headStructure FROM character_face WHERE cid = :cid LIMIT 1", { cid = character.info.id })
			if Face and Face[1] then
				character['cPed']['hairColor'] = json.decode(Face[1].hairColor)
				character['cPed']['headBlend'] = json.decode(Face[1].headBlend)
				character['cPed']['headOverlay'] = json.decode(Face[1].headOverlay)
				character['cPed']['headStructure'] = json.decode(Face[1].headStructure)
			end
	
			local Tats = exports.oxmysql:executeSync("SELECT tattoos FROM playersTattoos WHERE cid = :cid LIMIT 1", { cid = character.info.id })
			if Tats and Tats[1] and Tats[1]['tattoos'] then
				character['cPed']['tattoos'] = json.decode(Tats[1].tattoos)
			end
	
			plyCharacters[i] = character

		end

		TriggerClientEvent('fetchCharacters', source, plyCharacters)

	end,

	SelectCharacter = function(self, source, cid)

		if self.Players[source] then return end;

		local plyIdentifier = self:GetIdentifier(source)
		if not plyIdentifier then DropPlayer(source, 'Missing FiveM identifier') return end;

		exports.oxmysql:fetch('SELECT `cash`, `bank`, `job`, `job_grade`, `duty`, `firstname`, `lastname`, `phone_number`, `jail_time`, `gender`, `twitterhandle` FROM `users` WHERE `id`=:id LIMIT 1', { id = cid }, function(result)
		
			if not result then return end;

			local character = result[1]
			if not character then return end;

			local charInfo = {
				name = GetPlayerName(source),
				source = source,
				identifier = plyIdentifier,
				cid = cid,
				id = cid,
				cash = tonumber(character.cash),
				bank = tonumber(character.bank),
				job = {
					name = character.job,
					grade = character.job_grade,
					duty = tonumber(character.duty),
					isPolice = false
				},
				sidejob = { 
					name = "none", 
					label = "None" 
				},
				firstname = character.firstname,
				lastname = character.lastname,
				fullname = ('%s %s'):format(character.firstname, character.lastname),
				gender = character.gender,
				phone_number = character.phone_number,
				-- Removed: jail_time & twitterhandle
			}

			local isPolice = self.PoliceJobs[character.job] or false
			charInfo.job.isPolice = isPolice

			self.Players[source] = charInfo
			self.PlayersCid[cid] = source

			local thirst = GetResourceKvpInt(cid.."-thirst")
			if thirst == 0 or thirst == nil then thirst = 5000 end

			local hunger = GetResourceKvpInt(cid.."-hunger")
			if hunger == 0 or hunger == nil then hunger = 5000 end

			local tempInfo = {
				coords = GetResourceKvpString(cid.."-coords"),
				armor = GetResourceKvpInt(cid.."-armour"),
				thirst = thirst,
				hunger = hunger,
				stress = GetResourceKvpInt(cid.."-stress"),
				jail_time = character.jail_time,
				twitterhandle = character.twitterhandle
			}

			self:SetPlayerBucket(source, 0)
			TriggerClientEvent('echorp_fx:spawnPlayer', source, charInfo, tempInfo)
			
			local discordMessage = ('Player: **%s** (**%s**)\nCharacter: **%s** (**%s**)\nIdentifier: **%s**\nCash: `%s` · Bank: `%s` · Job: `%s` | `%s`'):format(
				charInfo.name,
				source,
				charInfo.fullname,
				cid,
				plyIdentifier,
				'$'..character.cash,
				'$'..character.bank,
				character.job,
				character.job_grade
			)

			exports['erp_adminmenu']:sendToDiscord('Character Login', discordMessage, "8598763", GetConvar('gamelogs_webhook', ''))

		end)

	end,

	LogoutCharacter = function(self, source, disconnect)
		
		local charInfo = self.Players[source]
		if not charInfo then return end;

		self.Players[source] = nil
		self.PlayersCid[charInfo.cid] = nil

		if disconnect then
			TriggerEvent('echorp:playerDropped', charInfo)
		else
			TriggerClientEvent('echorp_fx:doLogout', source, charInfo)
			TriggerEvent('echorp_fx:doLogout', charInfo)
		end

		local discordMessage = ('Player: **%s** (**%s**)\nCharacter: **%s** (**%s**)\nIdentifier: **%s**\nCash: `%s` · Bank: `%s` · Job: `%s` | `%s`'):format(
			charInfo.name,
			source,
			charInfo.fullname,
			cid,
			charInfo.identifier,
			'$'..charInfo.cash,
			'$'..charInfo.bank,
			charInfo.job,
			charInfo.job_grade
		)

		exports['erp_adminmenu']:sendToDiscord('Character Logout', discordMessage, "16758838", GetConvar('gamelogs_webhook', ''))

		if disconnect then return end;

		self:HandleJoin(source)

	end,

	DeleteCharacter = function(self, source, cid)

		exports.oxmysql:execute("SELECT `identifier` FROM `users` WHERE id=:id LIMIT 1", {
			id = cid,
		}, function(data)

			local charData = data[1]
			if not charData then return end;
			
			local plyIdentifier = self:GetIdentifier(source)
			if not plyIdentifier then DropPlayer(source, 'Missing FiveM identifier') return end;

			if not (data[1]['identifier'] == plyIdentifier) then exports['erp_adminmenu']:BanPlayer(source, 'Framework Exploit #1', 69) end

			exports.oxmysql:executeSync("UPDATE `users` SET `deleted`='1' WHERE id=:id", { id = cid })

		end)

	end,

	KnownTables = {
		{ table = 'apartments', column = 'cid' },
		{ table = 'bank_history', column = 'cid' },
		{ table = 'billing', column = 'target' },
		{ table = 'billing', column = 'sendercid' },
		{ table = 'casinobalance', column = 'cid' },
		{ table = 'character_current', column = 'cid' },
		{ table = 'character_face', column = 'cid' },
		{ table = 'character_outfits', column = 'cid' },
		{ table = 'cryptoplayers', column = 'identifier' },
		{ table = 'emsmdtdata', column = 'cid' },
		{ table = 'housing', column = 'cid' },
		{ table = 'licenses', column = 'cid' },
		{ table = 'owned_vehicles', column = 'owner' },
		{ table = 'phone_contacts', column = 'cid' },
		{ table = 'playerstattoos', column = 'cid' },
		{ table = 'player_communityservice', column = 'citizenid' },
		{ table = 'policemdtdata', column = 'cid' },
		{ table = 'scenes', column = 'cid' },
		{ table = 'user_jobs', column = 'cid' },
		{ table = 'weed', column = 'cid' },
	},

	GenerateCid = function()
		local query = [[SELECT id + 1000 FROM users mo WHERE NOT EXISTS (SELECT NULL FROM users mi WHERE mi.id = mo.id + 1000 ) ORDER BY id LIMIT 1]]
		return exports['oxmysql']:executeSync(query, {})[1]["id + 1000"]
	end,

	CreateCharacter = function(self, source, data)
		local plyIdentifier = self:GetIdentifier(source)
		if not plyIdentifier then DropPlayer(source, 'Missing FiveM identifier') return end;

		local citizenId = self:GenerateCid()

		for i=1, #self.KnownTables do 
			local tableInfo = self.KnownTables[i]
			exports.oxmysql:executeSync("DELETE FROM `"..tableInfo['table'].."` WHERE `"..tableInfo['column'].."`= :citizenId", {
				citizenId = citizenId
			})
		end

		exports.oxmysql:insertSync("INSERT INTO `users` (`id`, `identifier`, `firstname`, `lastname`, `dateofbirth`, `gender`) VALUES (:id, :identifier, :firstname, :lastname, :dateofbirth, :gender)", {
			id = citizenId,
			identifier = plyIdentifier,
			firstname = data.firstname,
			lastname = data.lastname,
			dateofbirth = data.dob,
			gender = data.gender
		})

	end,

	PlayerFilter = {
		['source'] = function(self, source)
			return self.Players[source]
		end,
		['cid'] = function(self, cid)
			return self.Players[self.PlayersCid[cid]]
		end,
		['phone'] = function(self, phone)
			local phoneNumber = tostring(phone)
			for k,v in pairs(self.Players) do
				if v.phone_number == phoneNumber then return v end
			end
			return nil
		end,
	},

	-- START: Exports

	GetPlayerInfo = function(self, source, filter)
		return self.PlayerFilter[filter](self, source) or nil
	end,

	GetPlayerInfoOne = function(self, source, filter, cid)
		if cid then source = self.PlayersCid[source] end
		if not source then return end;
		local player = self.Players[source]
		if not player then return end
		return player[filter] 
	end,

	DoesCidExist = function(self, cid)
		return #exports.oxmysql:executeSync("SELECT 1 FROM users WHERE `id`=:id LIMIT 1", { id = cid }) > 0
	end,

	UpdatePlayerInfo = function(self, source, filter, data)
		self.Players[source][filter] = data
		TriggerClientEvent('echorp_fx:updateinfo', source, filter, data)
	end,

	GetPlayers = function(self)
		return self.Players
	end,

	-- END: Exports

	DeleteVehicle = function(self, netId)
		if not netId then return end;
		return DeleteEntity(NetworkGetEntityFromNetworkId(netId))
	end,

	SaveData = function(self)
		for k,v in pairs(self.Players) do 
			local plyPed = GetPlayerPed(v.source)
			local statePlayer = Player(v.source)
			SetResourceKvpNoSync(v['cid']..'-coords', json.encode(GetEntityCoords(plyPed)))
			SetResourceKvpIntNoSync(v['cid']..'-armour', GetPedArmour(plyPed))
			SetResourceKvpIntNoSync(v['cid']..'-stress', statePlayer.state.stressLevel)
			SetResourceKvpIntNoSync(v['cid']..'-thirst', statePlayer.state.thirstLevel)
			SetResourceKvpIntNoSync(v['cid']..'-hunger', statePlayer.state.hungerLevel)
			Wait(100)
		end
		FlushResourceKvp()
	end

}

exports('getPlayerInfo', function(...) -- exports['echorp_fx']:getPlayerInfo(source, 'source')
	return FRAMEWORK.MAIN:GetPlayerInfo(...)
end) 

exports('getPlayerInfoOne', function(...) -- exports['echorp_fx']:getPlayerInfoOne(source, 'cid', false)
	return FRAMEWORK.MAIN:GetPlayerInfoOne(...) -- exports['echorp_fx']:getPlayerInfoOne(cid, 'source', true)
end) 

exports('doesCidExist', function(...) -- exports['echorp_fx']:doesCidExist(cid)
	return FRAMEWORK.MAIN:DoesCidExist(...)
end) 

exports('updatePlayerInfo', function(...) -- exports['echorp_fx']:updatePlayerInfo(source, 'cid', 1000)
	return FRAMEWORK.MAIN:UpdatePlayerInfo(...)
end) 

exports('getPlayers', function(...) -- exports['echorp_fx']:getPlayers()
	return FRAMEWORK.MAIN:GetPlayers(...)
end) 

exports('getIdentifier', function(...) -- exports['echorp_fx']:getIdentifier(source)
	return FRAMEWORK.MAIN:GetIdentifier(...)
end) 

RegisterNetEvent('echorp_fx:playerJoined', function()
	FRAMEWORK.MAIN:HandleJoin(source)
end)

RegisterNetEvent('echorp_fx:fetchCharacters', function()
	FRAMEWORK.MAIN:FetchCharacters(source)
end)

RegisterNetEvent('echorp_fx:selectCharacter', function(cid)
	FRAMEWORK.MAIN:SelectCharacter(source, tonumber(cid))
end)

RegisterNetEvent('echorp_fx:logoutCharacter', function()
	FRAMEWORK.MAIN:LogoutCharacter(source, false)
end)

AddEventHandler('playerDropped', function()
	FRAMEWORK.MAIN:LogoutCharacter(source, true)
end)

RegisterNetEvent('echorp_fx:deleteCharacter', function(cid)
	FRAMEWORK.MAIN:DeleteCharacter(source, cid)
end)

RegisterNetEvent('echorp_fx:createCharacter', function(charData)
	FRAMEWORK.MAIN:CreateCharacter(source, charData)
end)

RegisterNetEvent('deletevehicle:server', function(netId) -- Rename to echorp_fx:
	FRAMEWORK.MAIN:DeleteVehicle(netId)
end)

RegisterCommand("logout", function(source, args, rawCommand)
	TriggerClientEvent('echorp_fx:logout', source) 
end, false)

CreateThread(function()
	while true do
		Wait(15000)
		FRAMEWORK.MAIN:SaveData()
	end
end)

-- Old

AddEventHandler('echorp_fx:getplayerfromid', function(source, cb)
	cb(FRAMEWORK.MAIN.Players[source])
end)

AddEventHandler('echorp_fx:getplayerfromcid', function(cid, cb)
	cb(FRAMEWORK.MAIN.Players[FRAMEWORK.MAIN.PlayersCid[tonumber(cid)]])
end)