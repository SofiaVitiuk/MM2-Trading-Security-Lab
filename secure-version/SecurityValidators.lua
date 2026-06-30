-- SECURITY VALIDATORS (Reusable Security Functions)
-- ✅ Centralized validation logic

local SecurityValidators = {}

-- Validate player exists and is in game
function SecurityValidators.ValidatePlayer(player)
    if not player or not player.Parent then
        return false, "Player not in game"
    end
    return true
end

-- Validate item exists in database
function SecurityValidators.ValidateItem(itemId)
    local validItems = {
        "Knife", "Gun", "Revolver", "Sword"
    }
    for _, item in ipairs(validItems) do
        if item == itemId then return true end
    end
    return false, "Invalid item: " .. itemId
end

-- Validate quantity is reasonable
function SecurityValidators.ValidateQuantity(quantity)
    if quantity < 1 or quantity > 999 then
        return false, "Invalid quantity"
    end
    return true
end

-- Validate player isn't trading with themselves
function SecurityValidators.ValidateDifferentPlayers(player1, player2)
    if player1.UserId == player2.UserId then
        return false, "Cannot trade with yourself"
    end
    return true
end

-- Sanitize input from client
function SecurityValidators.SanitizeInput(data)
    local sanitized = {}
    sanitized.targetPlayerId = tonumber(data.targetPlayerId)
    sanitized.itemId = tostring(data.itemId)
    sanitized.quantity = math.floor(tonumber(data.quantity) or 1)
    return sanitized
end

return SecurityValidators