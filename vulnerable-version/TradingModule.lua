-- VULNERABLE TRADING MODULE (Educational Demo)
-- ⚠️ THIS CODE HAS SECURITY FLAWS ON PURPOSE

local TradingModule = {}

-- VULNERABILITY: No validation of items or players
function TradingModule.ExecuteTrade(player1, player2, itemId, quantity)
    print("[VULNERABLE] Executing trade: " .. itemId)
    
    -- VULNERABILITY #1: No check if player1 actually owns itemId
    print("[VULNERABLE] Not verifying player owns item!")
    
    -- VULNERABILITY #2: No atomic transaction
    -- If something fails here, state is inconsistent
    
    -- Simulate removing from player1
    print("Removing " .. itemId .. " from " .. player1.Name)
    
    -- VULNERABILITY #3: No rollback mechanism
    -- If next step fails, item is lost
    
    -- Simulate adding to player2
    print("Adding " .. itemId .. " to " .. player2.Name)
    
    -- VULNERABILITY #4: Success always returns true
    -- No actual validation
    return true
end

-- VULNERABILITY #5: No logging
-- function TradingModule.LogTrade(player1, player2, itemId)
--     -- Should log here but doesn't
-- end

return TradingModule