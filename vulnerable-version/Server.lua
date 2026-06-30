-- VULNERABLE TRADING SERVER (Educational Demo)
-- ⚠️ THIS CODE IS INTENTIONALLY INSECURE - DO NOT USE IN PRODUCTION

local TradingModule = require(script.Parent:WaitForChild("TradingModule"))
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent for trades
local TradeEvent = Instance.new("RemoteEvent")
TradeEvent.Name = "TradeEvent"
TradeEvent.Parent = ReplicatedStorage

-- Store player inventories (vulnerability: stored only on server memory)
local playerInventories = {}

-- VULNERABILITY #1: No validation - just trusts client data
TradeEvent.OnServerEvent:Connect(function(player, tradeData)
    print("[VULNERABLE] Player", player.Name, "initiated trade")
    
    -- VULNERABILITY: Accepts client-provided data without verification
    local itemId = tradeData.itemId
    local targetPlayerId = tradeData.targetPlayerId
    local quantity = tradeData.quantity or 1
    
    local targetPlayer = Players:FindFirstChild(targetPlayerId)
    if not targetPlayer then
        print("[ERROR] Target player not found")
        return
    end
    
    -- VULNERABILITY #2: No server-side inventory check
    -- Just ASSUMES the player has the item
    print("[VULNERABLE] Not checking if player actually has item!")
    
    -- VULNERABILITY #3: No atomic transaction
    -- If this fails halfway, items disappear
    local success = TradingModule.ExecuteTrade(player, targetPlayer, itemId, quantity)
    
    if success then
        print("[VULNERABLE] Trade completed without proper validation!")
        -- Send confirmation (but no verification happened)
        TradeEvent:FireClient(player, {
            success = true,
            message = "Trade complete"
        })
    end
end)

-- VULNERABILITY #4: No audit logging
-- Players.PlayerAdded:Connect(function(player)
--     -- Could log trades here, but this version doesn't
-- end)

print("[VULNERABLE SERVER LOADED] This server accepts any trade without validation!")