print(('%sLoaded blips module!'):format(FRAMEWORK.DebugPrint))

FRAMEWORK.BLIPS = {
	Blips = {},
	SavedKVP = {},

	CreateBlip = function(self, params)
		local blip = 0

		if params['group'] and params['group'] ~= "" then
			if not self.Blips[params['group']] then self.Blips[params['group']] = {} end -- Create the group if it's not been used before.
			
			local displayType = self.SavedKVP[params['group']]
			if not displayType then
				displayType = GetResourceKvpInt("hidden-blip-"..params['group'])
				if displayType == 0 then
					SetResourceKvpInt("hidden-blip-"..params['group'], 2)
					displayType = 2
				end
				self.SavedKVP[params['group']] = displayType
			end
	
			blip = AddBlipForCoord(params['coords'].x, params['coords'].y, params['coords'].z)    
			SetBlipSprite(blip, params['sprite'])
			SetBlipScale(blip, params['scale'] or 0.8)
			SetBlipColour(blip, params['color'] or 0)
			SetBlipDisplay(blip, displayType)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(params['text'])
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip, params['scale'] or false)
	
			self.Blips[params['group']][#self.Blips[params['group']]+1] = {
				blip = blip, 
				resource = params['resource']
			}

		else
			blip = AddBlipForCoord(params['coords'])    
			SetBlipSprite(blip, params['sprite'])
			SetBlipScale(blip, params['scale'] or 0.8)
			SetBlipColour(blip, params['color'] or 0)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(params['text'])
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip, params['scale'] or false)
		end
		return blip
	end,


	GetGroups = function(self)
		local Groups = {}
		for k,v in pairs(self.Blips) do
			Groups[k] = true
		end
		return Groups
	end,

	ToggleBlipGroup = function(self, group)
		local new = 0
		if GetResourceKvpInt("hidden-blip-"..group) == 1 then
			SetResourceKvpInt("hidden-blip-"..group, 2)
			new = 2
		else
			SetResourceKvpInt("hidden-blip-"..group, 1)
			new = 1
		end
	
		self.SavedKVP[group] = new
	
		for k,v in pairs(self.Blips) do
			if k == group then
				for i=1, #self.Blips[k] do
					SetBlipDisplay(self.Blips[k][i]['blip'], self.SavedKVP[group])
				end
			end
		end
	
		if self.SavedKVP[group] == 1 then
			exports['erp_notifications']:SendAlert('inform', 'Blips hidden.')
		elseif self.SavedKVP[group] == 2 then
			exports['erp_notifications']:SendAlert('inform', 'Blips visible.')
		end
	
		return true
	end,

	HandleResourceStop = function(self, resourceName)
		for k,v in pairs(self.Blips) do
			for i=1, #v do
				if resourceName == v[i].resource then
					RemoveBlip(v[i].blip)
				end
			end
		end
	end,

}

AddEventHandler('onResourceStop', function(resourceName)
	FRAMEWORK.BLIPS:HandleResourceStop(resourceName)
end)

exports('createBlip', function(...)
	return FRAMEWORK.BLIPS:CreateBlip(...)
end) 

--[[
		exports['echorp_fx']:createBlip({
		resource = GetCurrentResourceName(),
		group = "General",
		coords = prisonCoords,
		sprite = 188,
		scale = 0.8,
		color = 6,
		shortrange = true,
		text = 'Bolingbroke Penitentiary'
	})
]]

exports('getGroups', function()
	return FRAMEWORK.BLIPS:GetGroups()
end)

exports('toggleBlipGroup', function(group)
	return FRAMEWORK.BLIPS:ToggleBlipGroup(group)
end)

