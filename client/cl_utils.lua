print(('%sLoaded util module!'):format(FRAMEWORK.DebugPrint))

FRAMEWORK.FUNCTIONS = {

	CreateObject = function(self, params)

		if type(params.model) == 'string' then
			params.model = GetHashKey(params.model)
		end
		
		if not IsModelValid(params.model) then return end;

		RequestModel(params.model)
		while not HasModelLoaded(params.model) do Wait(0) end

		local object <const> = CreateObject(params.model, params.coords.x, params.coords.y, params.coords.z, params.network or true, false, false)		
		SetModelAsNoLongerNeeded(params.model)
		
		return object

	end,

}