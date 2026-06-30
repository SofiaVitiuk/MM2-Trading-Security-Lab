-- VULNERABLE TRADING CLIENT (Educational Demo)
-- ⚠️ THIS CODE IS INTENTIONALLY INSECURE

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for the trade event
local TradeEvent = ReplicatedStorage:WaitForChild("TradeEvent")

-- VULNERABILITY: Client-side inventory (can be edited!)
local clientInventory = {
    {id = "Knife", name = "Knife", quantity = 1},
    {id = "Gun", name = "Gun", quantity = 1}
}

-- Function to initiate a trade (vulnerable)
local function InitiateTrade(targetPlayer, itemId, quantity)
    print("[VULNERABLE CLIENT] Sending trade request...")
    
    -- VULNERABILITY #1: Client sends trade directly
    -- Server has NO WAY to verify this is legitimate
    local tradeData = {
        itemId = itemId,
        targetPlayerId = targetPlayer.Name,
        quantity = quantity or 1
    }
    
    -- VULNERABILITY #2: No wait for server confirmation
    -- Just sends and assumes it works
    TradeEvent:FireServer(tradeData)
    print("[VULNERABLE] Trade sent! No verification needed!")
end

-- VULNERABILITY #3: Client can fake having items
local function FakeItemInInventory(fakeItemId)
    print("[EXPLOIT] Adding fake item to client inventory:" .. fakeItemId)
    table.insert(clientInventory, {
        id = fakeItemId,
        name = fakeItemId,
        quantity = 999
    })
    print("[EXPLOIT] Fake item added! Now client can trade it!")
end

-- Example: How to exploit this
-- Uncomment to test vulnerability:
-- FakeItemInInventory("GodGun")
-- InitiateTrade(game.Players:FindFirstChild("VictimName"), "GodGun", 999)

print("[VULNERABLE CLIENT LOADED] Ready to send unvalidated trades!")