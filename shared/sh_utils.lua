print(('%sLoaded shared/utils module!'):format(FRAMEWORK.DebugPrint))

FRAMEWORK.UTILS = {

	MathRound = function(self, value, decimalPoints)
		if decimalPoints then return math.floor((value * 10^decimalPoints) + 0.5) / (10^decimalPoints) end
		return math.floor(value + 0.5)
	end,

	Round = function(self, value, decimalPoints)
		return self:MathRound(value, decimalPoints)
	end,

	CommaValue = function(self, amount)
		local formatted = amount
		while true do
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
			if (k==0) then break end
		end
		return formatted
	end,

	MathTrim = function(self, value)
		return string.gsub(value, "^%s*(.-)%s*$", "%1")
	end,

}

exports('round', function(...)
	return FRAMEWORK.UTILS:Round(...)
end) 

exports('getRandomString', function(...)
	return FRAMEWORK.UTILS:GetRandomString(...)
end) 

exports('commaValue', function(...)
	return FRAMEWORK.UTILS:CommaValue(...)
end)

exports('mathTrim', function(...)
	return FRAMEWORK.UTILS:MathTrim(...)
end)