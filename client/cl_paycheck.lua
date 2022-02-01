print(('%sLoaded paycheck module!'):format(FRAMEWORK.DebugPrint))

CreateThread(function()

	local PaycheckPos, Prompt = vector3(-1083.28, -245.89, 37.76), false

	while true do
		local waitTimer = 1000;
		
		local plyPos = GetEntityCoords(PlayerPedId())
		local paycheckDist = #(plyPos - PaycheckPos)

		if paycheckDist < 5.0 then

			waitTimer = 0;

			if not Prompt then
				TriggerEvent('erp-prompts:ShowUI', 'show', '[E] Collect Paycheck')
				Prompt = true
			end

			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('echorp_fx:collectpaycheck')
				waitTimer = 1000
			end

		elseif Prompt then
			TriggerEvent('erp-prompts:HideUI')
			Prompt = false
		end

		Wait(waitTimer)
	end

end)