# Setup Guide: Running the Lab

## Prerequisites

- Roblox Studio (free)
- Basic Lua knowledge
- Text editor (VS Code, Sublime, etc)

## Step 1: Create a Test Game in Roblox Studio

1. Open Roblox Studio
2. Create new "Baseplate" template
3. Save as "MM2-Trading-Lab"

## Step 2: Set Up Folder Structure

In your game, create this structure in **ServerScriptService**:

```
ServerScriptService/
├── TradeServer (Script)
├── TradingModule (ModuleScript)
└── SecurityValidators (ModuleScript)

ReplicatedStorage/
└── (RemoteEvents created by script)
```

## Step 3: Run Vulnerable Version First

### Copy to ServerScriptService:

**File 1: TradingModule (ModuleScript)**
- Copy code from `vulnerable-version/TradingModule.lua`

**File 2: TradeServer (Script)**
- Copy code from `vulnerable-version/Server.lua`

**File 3: TradeClient (LocalScript in StarterPlayer > StarterCharacterScripts)**
- Copy code from `vulnerable-version/Client.lua`

## Step 4: Test the Vulnerability

1. Start game with 2 players
2. Open Command Bar (View > Output)
3. Run script from `exploits/test-vulnerability.lua` in Command Bar
4. Observe: Server accepts invalid trades!

## Step 5: Switch to Secure Version

1. Replace files with `secure-version/` code
2. Add `SecurityValidators` ModuleScript
3. Run tests again
4. Observe: Server rejects all invalid trades!

## Step 6: Compare & Learn

1. Open both versions side-by-side
2. Read `docs/SECURITY_ANALYSIS.md`
3. Identify differences
4. Understand WHY each change adds security

## Testing Checklist

- [ ] Can send fake items (vulnerable) / Rejected (secure)
- [ ] Can trade 999 items with 1 (vulnerable) / Rejected (secure)
- [ ] Can spam trades (vulnerable) / Rate limited (secure)
- [ ] Server logs trades (secure only)
- [ ] Invalid data handled (secure only)

## Troubleshooting

**Error: RemoteEvent not found**
- Make sure TradeServer script is running
- Check ReplicatedStorage for TradeEvent

**Trades not working**
- Check console for errors
- Make sure you have 2 players
- Verify script paths are correct

**Can't run test script**
- Copy-paste into Command Bar line by line
- Or save as LocalScript and run

## Next Steps

1. ✅ Understand vulnerable system
2. ✅ Try exploits
3. ✅ Study secure system
4. ✅ Build your own secure trading system
5. ✅ Test it against exploits

---

**Have questions? Review the code comments and docs/**