print(('%sLoaded client main module!'):format(FRAMEWORK.DebugPrint))

UTILS = {

}

FRAMEWORK.MAIN = {

	Character = {},

	NetworkLoaded = function(self, logout)
		ShutdownLoadingScreenNui() -- REQUIRED
		exports['erp-spawn']:spawnCamera()
		if logout then return end;
		TriggerServerEvent('echorp_fx:playerJoined')
	end,

	UpdatePlayerInfo = function(self, change, data)
		self.Character[change] = data
	end,

	SpawnCharacter = function(self, characterInfo, temporaryInfo)

		self.Character = characterInfo

		local coords = json.decode(temporaryInfo.coords)
		if not coords then coords = vector3(-206.19, -1013.78, 30.13) end
		
		exports.spawnmanager:spawnPlayer({
			x = coords.x,
			y = coords.y,
			z = coords.z,
			heading = 90.0,
			skipFade = true
		}, function()
			TriggerServerEvent('echorp_fx:playerSpawned', characterInfo, temporaryInfo)
			TriggerEvent('echorp_fx:playerSpawned', characterInfo, temporaryInfo)
		end)

	end,

	LogoutCharacter = function(self)
		if not exports["erp-police"]:IsAvailable() then exports['erp_notifications']:SendAlert('error', 'Unable to log you out.', 5000) end;
		TriggerServerEvent('echorp_fx:logoutCharacter')
		exports['erp_notifications']:SendAlert('success', 'Logging you out...', 2500)
		self.Character = {}
		self:NetworkLoaded(true)
	end,

	GetCharacterInfo = function(self)
		return self.Character
	end,

	GetCharacterInfoOne = function(self, filter)
		return self.Character[filter] or nil
	end,

}

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			FRAMEWORK.MAIN:NetworkLoaded()
			return
		end
	end
end)

RegisterNetEvent('echorp_fx:spawnPlayer', function(characterInfo, temporaryInfo)
	FRAMEWORK.MAIN:SpawnCharacter(characterInfo, temporaryInfo)
end)

RegisterNetEvent('echorp_fx:logout', function()
	FRAMEWORK.MAIN:LogoutCharacter()
end)

RegisterNetEvent('echorp_fx:updateinfo', function(change, data) 
	FRAMEWORK.MAIN:UpdatePlayerInfo(change, data)
end)

exports('getCharacterInfo', function() -- exports['echorp_fx']:getCharacterInfo()
	return FRAMEWORK.MAIN:GetCharacterInfo()
end) 

exports('getCharacterInfoOne', function(filter) -- exports['echorp_fx']:getCharacterInfoOne('bank')
	return FRAMEWORK.MAIN:GetCharacterInfoOne(filter)
end) 

RegisterKeyMapping("+maincontrol", "Main Control", "keyboard", "E")
RegisterCommand("-maincontrol", function() end, false) -- Disables chat from opening.
RegisterCommand("+maincontrol", function(source, args, rawCommand) TriggerEvent('echorp_fx:maincontrol') end, false)