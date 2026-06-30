# VULNERABLE TRADING SYSTEM (For Learning)

## ⚠️ THIS CODE IS INTENTIONALLY BROKEN

This version demonstrates how NOT to build a trading system.

## Key Vulnerabilities

### 1. Client-Side State Trust
The server TRUSTS what the client sends:
```lua
-- BAD: Server accepts client data without verification
local itemId = data.itemId  -- Could be ANYTHING
local playerId = data.playerId  -- Could be FAKE
```

### 2. No Inventory Validation
Trade happens without checking if player actually HAS the item:
```lua
-- BAD: Never checks if player owns item before trading
function trade(player, itemId, otherPlayer)
    -- Just removes item! No validation!
    player.Backpack:RemoveItem(itemId)
end
```

### 3. No Server-Side Confirmation
Once client says "trade", it's done. No checks.

### 4. No Transaction Logging
No way to audit or rollback trades.

## How to Exploit This

### Exploit #1: Send Fake Item ID
```lua
-- Client sends trade request
local data = {
    itemId = "INFINITE_GODGUN",  -- Doesn't even exist!
    targetPlayer = "victim"
}
replicatedStorage:WaitForChild("TradeEvent"):FireServer(data)
```

### Exploit #2: Duplicate Items
```lua
-- Send same trade twice at same time (race condition)
replicatedStorage:WaitForChild("TradeEvent"):FireServer(data)
replicatedStorage:WaitForChild("TradeEvent"):FireServer(data)
-- Both go through before server processes first one!
```

### Exploit #3: Trade Without Items
```lua
-- Claim to trade item you don't have
local data = {
    itemId = "GodGun",
    quantity = 999  -- You only have 1!
}
replicatedStorage:WaitForChild("TradeEvent"):FireServer(data)
```

## Files
- `Server.lua` - Insecure server code
- `Client.lua` - Vulnerable client code
- `TradingModule.lua` - Broken trading logic

## Next Steps
1. Read the code and spot the vulnerabilities
2. Try the exploits
3. Check `../secure-version/` to see how to fix it