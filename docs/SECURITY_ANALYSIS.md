# Security Analysis: Trading System Vulnerabilities

## Executive Summary

This document analyzes common security vulnerabilities in trading systems and how to prevent them.

---

## Vulnerability #1: Client-Side State Trust

### The Problem
```lua
-- BAD: Server trusts client
local itemId = clientData.itemId
local playerId = clientData.playerId
-- Server just accepts this!
```

### Why It's Dangerous
- Client can send ANY data
- Network intercept can modify requests
- Player can mod the game to send fake data

### The Solution
```lua
-- GOOD: Server verifies everything
local playerId = player.UserId  -- Use server's authentication
local itemId = tostring(clientData.itemId)  -- Sanitize input
local itemExists = ValidateItem(itemId)  -- Verify item is real
local playerOwnsItem = CheckInventory(player, itemId)  -- Verify ownership
```

---

## Vulnerability #2: Missing Inventory Validation

### The Problem
```lua
-- BAD: Never checks if player has the item
function ExecuteTrade(player, itemId)
    RemoveFromInventory(player, itemId)  -- Just removes it!
    -- What if they didn't have it?
end
```

### Why It's Dangerous
- Players can trade items they don't own
- Causes item duplication
- Breaks game economy

### The Solution
```lua
-- GOOD: Verify first, then trade
if not PlayerOwnsItem(player, itemId, quantity) then
    return false, "Item not found"
end
RemoveFromInventory(player, itemId, quantity)
```

---

## Vulnerability #3: Non-Atomic Transactions

### The Problem
```lua
-- BAD: Multiple steps, can fail halfway
RemoveFromPlayer1()  -- If server crashes here:
AddToPlayer2()       -- Player1 lost item, Player2 didn't get it
LogTrade()           -- Log never created
```

### Why It's Dangerous
- Items disappear
- Inconsistent state
- Impossible to rollback

### The Solution
```lua
-- GOOD: All-or-nothing
local success, err = pcall(function()
    RemoveFromPlayer1()
    AddToPlayer2()
    LogTrade()
end)

if not success then
    RollbackTrade()  -- Undo everything
end
```

---

## Vulnerability #4: No Rate Limiting

### The Problem
```lua
-- Player can spam trades
for i = 1, 1000 do
    TradeEvent:FireServer(data)  -- All accepted!
end
```

### Why It's Dangerous
- Duplicate trades
- Item duplication
- Server overload

### The Solution
```lua
-- Track last trade time
if now - lastTradeTime < 2 then  -- Min 2 seconds
    return false, "Trade cooldown"
end
playerInventories[userId].lastTradeTime = now
```

---

## Vulnerability #5: No Audit Logging

### The Problem
```lua
-- No way to track what happened
function ExecuteTrade(player1, player2, item)
    -- Trade happens but nothing is logged
    -- If exploited, no proof
end
```

### Why It's Dangerous
- Can't detect exploits
- Can't rollback trades
- No accountability

### The Solution
```lua
-- Log every trade
function LogTrade(player1, player2, itemId, quantity)
    SaveToDatabase({
        timestamp = tick(),
        player1 = player1.UserId,
        player2 = player2.UserId,
        item = itemId,
        quantity = quantity,
        status = "completed"
    })
end
```

---

## Security Checklist

When designing a trading system:

- [ ] Server validates all inputs
- [ ] Client cannot modify state
- [ ] Inventory checked before trade
- [ ] Transactions are atomic
- [ ] Rate limiting active
- [ ] All trades logged
- [ ] Players verified (not self-trades)
- [ ] Data types validated
- [ ] Error handling with rollback
- [ ] Server is source of truth

---

## Best Practices

### 1. Server-Side Authority
**The server is ALWAYS right.** The client is just display.

```lua
-- Server knows:
-- - What items player has
-- - What inventory looks like
-- - What trades are valid
-- Client just shows this to player
```

### 2. Never Trust Client Input
```lua
-- Assume ALL client data is compromised
-- Validate EVERYTHING
-- Always re-verify on server
```

### 3. Fail Securely
```lua
-- If uncertain, reject the trade
-- Never accept questionable trades
-- Err on the side of security
```

### 4. Log Everything
```lua
-- Every trade: WHO, WHAT, WHEN, WHERE
-- Use for auditing and rollback
-- Monitor for suspicious patterns
```

### 5. Test Security
```lua
-- Try to break your own system
-- Send invalid data
-- Attempt race conditions
-- Verify it rejects everything bad
```

---

## Common Mistakes

❌ **MISTAKE**: Trusting client-side inventory  
✅ **CORRECT**: Keeping inventory on server

❌ **MISTAKE**: Not checking if player owns item  
✅ **CORRECT**: Verifying ownership before trade

❌ **MISTAKE**: Removing item without confirmation  
✅ **CORRECT**: Using atomic transactions

❌ **MISTAKE**: Allowing unlimited rapid trades  
✅ **CORRECT**: Rate limiting trades

❌ **MISTAKE**: Not logging trades  
✅ **CORRECT**: Logging everything for audit

---

## References

- CWE-347: Improper Verification of Cryptographic Signature
- CWE-346: Origin Validation Error
- OWASP: Broken Access Control
- Game Security: Authoritative Servers in Game Development