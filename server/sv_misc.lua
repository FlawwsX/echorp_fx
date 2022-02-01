print(('%sLoaded misc module!'):format(FRAMEWORK.DebugPrint))

FRAMEWORK.MISC = {

	TokenTypes = {
		['Ringtone'] = true,
		['Number'] = true,
		['Plate'] = true,
		['Handle'] = true
	},

	CopyCoords = function(self, type, source)
		local plyPed = GetPlayerPed(source)
		local plyPos = GetEntityCoords(plyPed)
		local plyPosPrint = "Unknown, this could be due to lack of onesync!"
		
		if type == 'vector4' then
			local plyHeading = GetEntityHeading(plyPed)
			plyPosPrint = ('vector4(%s, %s, %s, %s)'):format( string.format("%.2f", plyPos.x), string.format("%.2f", plyPos.y), string.format("%.2f", plyPos.z), string.format("%.2f", plyHeading) )
		else
			plyPosPrint = ('vector3(%s, %s, %s)'):format( string.format("%.2f", plyPos.x), string.format("%.2f", plyPos.y), string.format("%.2f", plyPos.z) )
		end

		TriggerEvent('erp_adminmenu:discord', 'Coords From: '..GetPlayerName(source), plyPosPrint, '3252448', "https://discord.com/api/webhooks/920080472405598268/EovEx3nGp575ZmM7Z_KkWgz0Zj1b930jkRpm-_TVZs2so7f3fqCrgiMXQg2sW-Xml1xs")

	end,

	AddToken = function(self, type, discord, source)
		if type then
			if self.TokenTypes[type] then
				if discord then
					exports.oxmysql:executeSync('INSERT INTO `donatorperks` (`type`, `discord`) VALUES (:type, :discord);', { type = type, discord = discord })
					TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'inform', text = "Donator perk added.", length = 5000 })
				else
					TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'inform', text = "You did not provide a discord ID", length = 5000 })
				end
			else
				TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'inform', text = "Invalid token type - Try ringtone, number, plate or handle.", length = 5000 })
			end
		else
			TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'inform', text = "You failed to provide a token type - Try ringtone, number, plate or handle.", length = 5000 })
		end
	end,

	RestartCooldown = function(self, eventData)
		if eventData.secondsRemaining <= 1800 then GlobalState.canRob = false end
	end

}

RegisterCommand("addtoken", function(source, args, rawCommand) FRAMEWORK.MISC:AddToken(args[1], args[2], source) end, true)
RegisterCommand("copycoords", function(source, args, rawCommand) FRAMEWORK.MISC:CopyCoords(args[1], source) end, false)

CreateThread(function() Wait(2500) GlobalState.canRob = false Wait(1800000) GlobalState.canRob = true end)
AddEventHandler('txAdmin:events:scheduledRestart', function(eventData) FRAMEWORK.MISC:RestartCooldown(eventData) end)