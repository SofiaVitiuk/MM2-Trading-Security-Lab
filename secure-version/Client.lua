-- SECURE TRADING CLIENT (Safe Implementation)
-- ✅ THIS CODE FOLLOWS SECURITY BEST PRACTICES

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait for the secure trade event
local TradeEvent = ReplicatedStorage:WaitForChild("SecureTradeEvent")

-- SECURITY: Client inventory is DISPLAY ONLY (server is authority)
local displayInventory = {
    {id = "Knife", name = "Knife", quantity = 1},
    {id = "Gun", name = "Gun", quantity = 1}
}

-- SECURE: Only send minimal, essential data
local function RequestTrade(targetPlayer, itemId, quantity)
    print("[SECURE CLIENT] Requesting trade from server...")
    
    -- SECURITY #1: Send only what's necessary
    -- Never send inventory data or fake items
    local tradeRequest = {
        targetPlayerId = targetPlayer.UserId,  -- Server will verify
        itemId = itemId,                        -- Server will verify ownership
        quantity = quantity or 1                -- Server will verify quantity
    }
    
    -- SECURITY #2: Wait for server response
    TradeEvent:FireServer(tradeRequest)
    
    -- SECURITY #3: Display result to user
    TradeEvent.OnClientEvent:Connect(function(result)
        if result.success then
            print("[SUCCESS] " .. result.message)
            -- Update display inventory from server in real game
        else
            print("[ERROR] " .. result.message)
            -- Do NOT update inventory
        end
    end)
end

-- SECURITY #4: Never modify client inventory directly
-- Always wait for server confirmation

-- Example usage:
-- RequestTrade(targetPlayer, "Knife", 1)

print("[SECURE CLIENT LOADED] Waiting for server responses!")