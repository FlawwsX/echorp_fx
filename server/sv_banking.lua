print(('%sLoaded banking module!'):format(FRAMEWORK.DebugPrint))

FRAMEWORK.BANKING = {

	DefaultTax = 0.0751,
	LogThreshold = 50000,

	Round = function(self, num, numDecimalPlaces)

		local mult = 10^(numDecimalPlaces or 0)
		return math.floor(num * mult + 0.5) / mult

	end,

	SplitTax = function(self, amount, type)

		if type == 'casino' then
			local dojSplit = amount * 0.80 -- 80%
			local casinoSplit = amount * 0.20 -- 20%
			exports.oxmysql:executeSync('UPDATE businesses SET funds=funds+:amount WHERE name="doj"', { amount = dojSplit })
			exports.oxmysql:executeSync('UPDATE businesses SET funds=funds+:amount WHERE name="casino"', { amount = casinoSplit })
			return
		end
		exports.oxmysql:executeSync('UPDATE businesses SET funds=funds+:amount WHERE name="doj"', { amount = amount })

	end,

	TaxPlayer = function(self, sentAmount, player, version, varTax)
		local amount = tonumber(sentAmount)
		local taxType = "default"
	
		if not varTax then varTax = self.DefaultTax end
		if type(varTax) == "table" then varTax, taxType = varTax.num, varTax.type end

		local taxAmount = amount * varTax

		self:SplitTax(taxAmount, taxType)
		local taxAmount = self:Round(taxAmount, 2)

		if version == 1 then
			local finalAmount = amount - taxAmount
			if player.source then
				TriggerClientEvent('erp_notifications:client:SendAlert', player.source, { type = 'inform', text = 'This transaction was taxed at a rate of '..varTax..'% ($'..taxAmount..')', length = 7500 })
			end
			return finalAmount
		elseif version == 2 then
			if player.source then
				TriggerClientEvent('erp_notifications:client:SendAlert', player.source, { type = 'inform', text = 'This transaction was taxed at a rate of 8.22% ($'..taxAmount..')', length = 7500 }) 
			end

			self:AdjustBank(player.cid, taxAmount, true, false)
		end


	end,

	ThresholdCheck = function(self, id, amount, funcName)
		if amount >= self.LogThreshold then
			local msg = ('Type: **%s**\nCitizen ID: **%s**\nAmount: $**%s**'):format(funcName, id, amount)
			exports['erp_adminmenu']:sendToDiscord('Keep an Eye - Money Threshold', msg, "222222", GetConvar('anticheat_webhook', ''))
		end
	end,

	AdjustBank = function(self, source, sentamount, isCid, shouldTax, taxVar)
		
		local p = promise.new()
		
		local id = source
		if not isCid then id = FRAMEWORK.MAIN:GetPlayerInfoOne(source, 'cid', false) end

		local amount = tonumber(sentamount)
		local player = FRAMEWORK.MAIN:GetPlayerInfo(id, 'cid')

		if shouldTax and amount > 0 then
			amount = self:TaxPlayer(amount, { source = player.source or false, cid = id }, 1, taxVar) 
		elseif shouldTax then
			self:TaxPlayer(amount, { source = player.source or false, cid = id }, 2, taxVar)
		end

		self:ThresholdCheck(id, amount, 'AdjustBank')

		exports.oxmysql:update("UPDATE users SET bank = bank+:amount WHERE id=:id", {
			amount = amount, 
			id = id
		}, function(endResult)
			if endResult > 0 then 
				if player then
					local newBank = self:Round(player.bank + amount)
					FRAMEWORK.MAIN:UpdatePlayerInfo(player.source, 'bank', newBank)
					if amount > 0 then
						TriggerClientEvent("banking:addBalance", player.source, amount)
					else
						TriggerClientEvent("banking:removeBalance", player.source, math.abs(amount))
					end
					TriggerClientEvent("banking:viewBalance", player.source, newBank)
				end
				p:resolve(true)
			else
				p:resolve(false)
			end
		end)

		return Citizen.Await(p)

	end,

	AdjustBankCommand = function(self, target, amount)

		if source > 0 and not IsPlayerAceAllowed(source, 'echorp.seniormod') then return end;

		if not target then
			if source > 0 then
				TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'inform', text = 'Please specify a CID, such as 1998', length = 5000 })
			end
			return
		end

		if not amount then
			if source > 0 then
				TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'inform', text = 'You failed to specify an amount greater than $0', length = 5000 })
			end
			return
		end

		local res = self:AdjustBank(target, amount, true, false)
		TriggerEvent('erp_adminmenu:discord', title, 'Add bank command', source..' added $'..amount..' to '..cid..'\'s bank!', '6003445', GetConvar('adminlogs_webhook', ''))

		if not res then return end;

		if source > 0 then
			TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'inform', text = 'We just gave someone $'..amount, length = 5000 })
		end

	end,

	TransferBank = function(self, source, sentTarget, sentAmount, shouldTax)

		local amount = tonumber(sentAmount)
		local target = tonumber(sentTarget)

		if not target or not amount then return end;
		if amount < 0 then return end; -- Exploit reasons.

		local player = FRAMEWORK.MAIN:GetPlayerInfo(source, 'source')
		if not player then return false end;

		local p = promise.new()

		exports.oxmysql:update("UPDATE users SET bank = bank-:amount WHERE id=:id", {
			amount = amount, 
			id = player.cid
		}, function(endResult)
			if endResult > 0 then
				local newBank = self:Round(player.bank - amount)
				FRAMEWORK.MAIN:UpdatePlayerInfo(player.source, 'bank', newBank)

				TriggerClientEvent("banking:removeBalance", player.source, amount)
				TriggerClientEvent("banking:viewBalance", player.source, newBank)

				exports.oxmysql:update("UPDATE users SET bank = bank+:amount WHERE id=:id", {amount = amount, id = target}, function(newResult)
					if endResult > 0 then
						local targetPly = FRAMEWORK.MAIN:GetPlayerInfo(target, 'cid')
						if targetPly then
							local newBank = self:Round(targetPly.bank + amount)
							FRAMEWORK.MAIN:UpdatePlayerInfo(targetPly.source, 'bank', newBank)
							TriggerClientEvent("banking:addBalance", targetPly.source, amount)
							TriggerClientEvent("banking:viewBalance", targetPly.source, newBank)
						end
						p:resolve(true)
					else
						p:resolve(false)
					end
				end)

			else
				p:resolve(false)
			end
		end)

		return Citizen.Await(p)

	end,

	AdjustCash = function(self, source, sentamount, isCid) -- exports['echorp_fx']:adjustCash(cid, amount, true)

		local p = promise.new()
		
		local id = source
		if not isCid then id = FRAMEWORK.MAIN:GetPlayerInfoOne(source, 'cid', false) end

		local amount = tonumber(sentamount)
		local player = FRAMEWORK.MAIN:GetPlayerInfo(id, 'cid')

		self:ThresholdCheck(id, amount, 'AdjustCash')

		exports.oxmysql:update("UPDATE users SET cash = cash+:amount WHERE id=:id", {
			amount = amount, 
			id = id
		}, function(endResult)
			if endResult > 0 then 
				if player then
					local newCash = self:Round(player.cash + amount)
					FRAMEWORK.MAIN:UpdatePlayerInfo(player.source, 'cash', newCash)
					if amount > 0 then
						TriggerClientEvent("banking:addCash", player.source, amount)
					else
						TriggerClientEvent("banking:removeCash", player.source, math.abs(amount))
					end
					TriggerClientEvent("banking:viewCash", player.source, newCash)
				end
				p:resolve(true)
			else
				p:resolve(false)
			end
		end)

		return Citizen.Await(p)

	end,

}

exports('adjustBank', function(...) -- exports['echorp_fx']:adjustBank(cid, amount, true, false)
	return FRAMEWORK.BANKING:AdjustBank(...)
end)

exports('transferBank', function(...) -- exports['echorp_fx']:transferBank(source, target, amount, true)
	return FRAMEWORK.BANKING:TransferBank(...)
end)

exports('adjustCash', function(...) -- exports['echorp_fx']:adjustCash(cid, amount, true)
	return FRAMEWORK.BANKING:AdjustCash(...)
end)

RegisterCommand("adjustbank", function(source, args, rawCommand) FRAMEWORK.BANKING:AdjustBankCommand(args[1], tonumber(args[2])) end, false)

--[[
	The adjustBank export can be used for add/remove bank.
	It also returns true upon success, false if not.
]]