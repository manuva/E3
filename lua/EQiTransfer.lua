--[[============================================================ 
EQi Transfer - Easy tranfer of most anything
Author: Dorien (Project Lazarus) - Randomice (Discord)
Date: Nov 30th 2023

This script will do a number of context-sensitive things around transfering items.
It will try to do the following in sequence and will stop as soon as one if successful:
    - Corpse: Loot the characters corpse
        If there is a corpse for this character nearby it will try to summon and loot it (must be within 100 feet).
    - Bank: Store items on the cursor in the bank
        If the Bank window is open, any item on the cursor will be stored in the bank using the Auto-Bank feature.
    - Merchant: Buy/Sell to/from a Merchant
        If a Merchant window is open and an item in the characters inventory is selected, that item will be sold.
        If a Merchant window is open and an item in the merchants inventory is selected, that item will be bought.
        Note: If the item is stackable upto a full stack will be bought/sold!
    - Tribute: Donate items for tribute
        If a Tribute Master window is open and an item in the inventory is selected, that item will be donated for Tribute.
        Note: If the item is stackable upto a full stack will be donated!
    - Trade: Add items or money for Trade with a PC
        If a Trade window is open, any item or money on the cursor will be added to the Trade window (if there are free slots).
    - Give: Add items or money to give to an NPC
        If a Give window is open with a NPC, any item or money on the cursor will be added to the Give window (if there are free slots).
    - Loot: 
        If there is a nearby NPC corpse, everything on that corpse will be looted (Loot All).
        Note: NoTrade or Lore items may interrupt the Loot All as normal.
    - Ground:
        If there is a nearby ground spawn (20 feet) that ground spawn will be picked up and added to inventory.
    - AutoInventory:
        If there are any items on the cursor, all those items are added to inventory.

Suggested use:
    - Create a subfolder in the MQ2E3Next/lua folder called '_' (underscore)
    - Place this script inside (EQiTransfer.lua)
    - Create a social called 'Transfer' and on the 1st line add:
        /lua run _/EQiTransfer
    - Place the Social in a HotButton
    - Hotkey the Hotbutton (I use the Mouse side button 'MOUS AUX 1')

============================================================ --]]

mq = require('mq')

-- ============================================================ 
-- Global variables

gsScriptLabel = '[EQiTransfer] '

-- ============================================================ 
-- Check for a nearby corpse, summon if neccessary (max 100 range)
-- Then loot it.
function LootMyCorpse()
    local oSpawn = mq.TLO.Spawn('pc corpse ' .. mq.TLO.Me.CleanName()) -- Find any of the player's corpses
    if (oSpawn == nil) then return false end                    -- If none found, exit
    
    oSpawn.DoTarget()                                           -- Target the corpse
    
    if (mq.TLO.Target() == nil) or (mq.TLO.Target.Type() ~= 'Corpse') then return false end           -- No corpse, exit
    if (mq.TLO.Target.Distance() > 2) and (mq.TLO.Target.Distance() <= 100) then
        mq.cmd.corpse()                                         -- Summon, and wait half a second for the corpse to arrive
        mq.delay(500)
    end
    if (mq.TLO.Target.Distance() > 2) then
        mq.cmd.echo(gsScriptLabel .. 'Your corpse is too far to loot. (' .. math.floor(mq.TLO.Target.Distance() + 0.5) .. ')') -- Too far to summon. /nav target will get you there, but mmust be done manually
        return true
    end

    AutoInventory()                                             -- AutoInventory. Can't loot with anything on the cursor

    mq.cmd.loot()                                               -- Open loot window
    mq.delay(2000, function() return (mq.TLO.Window('LootWnd').Open() == true) end)
    if (mq.TLO.Window('LootWnd').Open() == false) then          -- If no loot window is open (max delay 2s), then exit
        mq.cmd.echo(gsScriptLabel .. 'Unable to open Loot window.')
        return true
    end

    mq.cmd.notify('LootWnd LW_LootAllButton leftmouseup')       -- Loot all!
    return true
end

-- ============================================================ 
-- Storing whatever is on the cursor into the bank using the Auto-Bank button
function BigBankWnd()
    if (mq.TLO.Cursor.ID() == nil) then return false end        -- Nothing on the cursor, exit

    while (mq.TLO.Cursor.ID() ~= nil)                           -- Loop through everything on the cursor
    do
        mq.cmd.echo(gsScriptLabel .. 'Storing in bank: ' .. mq.TLO.Cursor.Name())
        mq.cmd.notify('BigBankWnd BIGB_AutoButton leftmouseup') -- And Auto-Bank it.
    end
    return true
end

-- ============================================================
-- Selling the selected item to the vendor, or buying selected item from the vendor.
-- Note: If it is a stackable item, the largest possible stack will be bought/sold.
function MerchantWnd()
    -- Check if the Merchant has received its Item list from the server (max 2s delay)
    mq.delay(2000, function() return (mq.TLO.Merchant.ItemsReceived()) end)
    if (mq.TLO.Merchant.ItemsReceived() == false) then
        mq.cmd.echo(gsScriptLabel .. 'Merchant did not receive item list.')
        return false
    end

    -- 2 situations:
    -- - Item selected in Inventory, then sell it
    -- - Item selected in the Merchant list, then buy it
    local oItem = nil
    local iCount = 1
    oItem = mq.TLO.SelectedItem
    if (oItem() ~= nil) then                                    -- Inventory item is selected, so sell it
        if (oItem.Stackable() == true) then
            iCount = oItem.Stack()
            mq.TLO.Merchant.Sell(iCount)                        -- Stackable item, so sell whatever is in the stack
        else
            mq.TLO.Merchant.Sell(iCount)                        -- Non-stackable, so sell 1
        end
        mq.cmd.echo(gsScriptLabel .. 'Sell : ' .. oItem.Name() .. ' x' .. tostring(iCount))
    else
        oItem = mq.TLO.Merchant.SelectedItem
        if (oItem() ~= nil) then                                -- Vendor item is selected, so buy it
            if (oItem.Stackable() == true) then
                if (oItem.FreeStack() == 0) then
                    iCount = oItem.StackSize()
                    mq.TLO.Merchant.Buy(iCount)                 -- Stackable item, no free stack, so buy a whole stack if possible
                else
                    iCount = oItem.FreeStack()
                    iCount = iCount % 1000
                    mq.TLO.Merchant.Buy(iCount)                 -- Stackable item, and a stack not full yet, so fill up the stack
                end
            else
                mq.TLO.Merchant.Buy(iCount)                     -- Non-stackable, so buy 1
            end
            mq.cmd.echo(gsScriptLabel .. 'Buy : ' .. oItem.Name() .. ' x' .. tostring(iCount))
        else
            mq.cmd.echo(gsScriptLabel .. 'No item selected.')  -- Nothing selected, exit
            return false
        end
    end

    return true
end

-- ============================================================ 
-- Donate selected item for Tribute
-- Note: If it is a stackable item, the entire stack will be donated
function TributeMasterWnd()
    local oItem = nil
    local iCount = 1
    oItem = mq.TLO.SelectedItem
    if (oItem() ~= nil) then                                    -- Inventory item is selected, tribute it
        mq.cmd.notify('TributeMasterWnd TMW_DonateButton leftmouseup')
        if (oItem.Stackable() == true) and (oItem.Stack() > 1) then
            mq.delay(2000, function() return (mq.TLO.Window('QuantityWnd').Open() == true) end)
            if (mq.TLO.Window('QuantityWnd').Open() == false) then
                mq.cmd.echo(gsScriptLabel .. 'Quantity window does not open.')
                return false
            end        
            mq.cmd.notify('QuantityWnd QTYW_Accept_Button leftmouseup')
        end
    end
end

-- ============================================================ 
-- Adds an item or money (p/g/s/c) that is on the cursor to an open PC Trade window
function TradeWnd()
    local iTargetId = mq.TLO.Target.ID()                        -- Get the target to trade with

    -- Always add money
    if (mq.TLO.Me.CursorCopper() ~= 0) or (mq.TLO.Me.CursorSilver() ~= 0) or (mq.TLO.Me.CursorGold() ~= 0) or (mq.TLO.Me.CursorPlatinum() ~= 0) then
        mq.cmd.echo(gsScriptLabel .. 'Adding to trade: ' .. mq.TLO.Me.CursorPlatinum() .. 'p ' .. mq.TLO.Me.CursorGold() .. 'g ' ..mq.TLO.Me.CursorSilver() .. 's ' ..mq.TLO.Me.CursorCopper() .. 'c ')
        mq.TLO.Spawn(iTargetId).LeftClick()                     -- Drop it on the target to add to the trade
        return true
    end

    if (mq.TLO.Cursor.ID() == nil) then return false end        -- Nothing on the cursor, exit

    -- For items, first check if there are any free Trade slots left
    if (mq.TLO.InvSlot(3000).Item() ~= nil) and (mq.TLO.InvSlot(3001).Item() ~= nil) and (mq.TLO.InvSlot(3002).Item() ~= nil) and (mq.TLO.InvSlot(3003).Item() ~= nil) and (mq.TLO.InvSlot(3004).Item() ~= nil) and (mq.TLO.InvSlot(3005).Item() ~= nil) and (mq.TLO.InvSlot(3006).Item() ~= nil) and (mq.TLO.InvSlot(3007).Item() ~= nil) then
        mq.cmd.echo(gsScriptLabel .. 'All your Trade slots are full.')
        return false
    end

    mq.cmd.echo(gsScriptLabel .. 'Adding to trade: ' .. mq.TLO.Cursor.Name())
    mq.TLO.Spawn(iTargetId).LeftClick()                         -- Drop it on the target to add to the trade
    return true
end

-- ============================================================ 
-- Adds an item or money (p/g/s/c) that is on the cursor to an open NPC Give window
function GiveWnd()
    local iTargetId = mq.TLO.Target.ID()                        -- Get the target to trade with

    -- Always add money
    if (mq.TLO.Me.CursorCopper() ~= 0) or (mq.TLO.Me.CursorSilver() ~= 0) or (mq.TLO.Me.CursorGold() ~= 0) or (mq.TLO.Me.CursorPlatinum() ~= 0) then
        mq.cmd.echo(gsScriptLabel .. 'Adding to trade: ' .. mq.TLO.Me.CursorPlatinum() .. 'p ' .. mq.TLO.Me.CursorGold() .. 'g ' ..mq.TLO.Me.CursorSilver() .. 's ' ..mq.TLO.Me.CursorCopper() .. 'c ')
        mq.TLO.Spawn(iTargetId).LeftClick()                     -- Drop it on the target to add to the trade
        return true
    end

    if (mq.TLO.Cursor.ID() == nil) then return false end        -- Nothing on the cursor, exit

    -- For items, first check if there are any free Give slots left
    if (mq.TLO.InvSlot(3000).Item() ~= nil) and (mq.TLO.InvSlot(3001).Item() ~= nil) and (mq.TLO.InvSlot(3002).Item() ~= nil) and (mq.TLO.InvSlot(3003).Item() ~= nil) then
        mq.cmd.echo(gsScriptLabel .. 'All your Give slots are full.')
        return false
    end

    mq.cmd.echo(gsScriptLabel .. 'Adding to Give: ' .. mq.TLO.Cursor.Name())
    mq.TLO.Spawn(iTargetId).LeftClick()                         -- Drop it on the target to add to the Give
    return true
end

-- ============================================================ 
-- Loot a nearby corpse
-- Note: E3N autoloot is faster and better.
function LootCorpse()
    local oSpawn = mq.TLO.Spawn('npc corpse radius 10')         -- Find a closeby corpse
    if (oSpawn == nil) then return false end                    -- If none found, exit
    oSpawn.DoTarget()                                           -- Target the corpse
    mq.delay(100)
    if (mq.TLO.Target() == nil) or (mq.TLO.Target.Type() ~= 'Corpse') then return false end           -- No corpse, exit

    AutoInventory()                                             -- AutoInventory. Can't loot with anything on the cursor

    mq.cmd.loot()                                               -- Open loot window
    mq.delay(2000, function() return (mq.TLO.Window('LootWnd').Open() == true) end)
    if (mq.TLO.Window('LootWnd').Open() == false) then          -- If no loot window is open (max delay 2s), then exit
        mq.cmd.echo(gsScriptLabel .. 'Unable to open Loot window.')
        return true
    end

    mq.cmd.notify('LootWnd LW_LootAllButton leftmouseup')       -- Loot all!
    return true
end

-- ============================================================ 
-- Grabs any ground spawn within range and autoinventory it
-- MacroQuest's TLO Ground is bugged!! This should work as long as you don't muck about with Ground stuff much
function GroundGrab()
    AutoInventory()

    mq.TLO.Ground.Reset()                                       -- To invalidate any previous Ground spawn searches
    if (mq.TLO.Ground.Distance() > 20) then
        -- mq.cmd.echo(gsScriptLabel .. 'Please move within 20 feet of the item you want to grab.')
        return false
    end

    if (mq.TLO.Ground.Grab() == false) then                     -- Grab!
        return false
    end

    mq.delay(500)                                               -- Wait for the graboid.
    local oItem = mq.TLO.Cursor
    mq.cmd.echo(gsScriptLabel .. 'Grabbed : ' .. oItem.Name())
    return AutoInventory()                                      -- Store!
end

-- ============================================================ 
-- Will /autoinventory everything on the cursor
function AutoInventory()
    if (mq.TLO.Cursor.ID() == nil) then return false end

    while (mq.TLO.Cursor.ID() ~= nil)                           -- Loop through everything on the cursor
    do
        mq.cmd.autoinventory()                                  -- And auto-inventory it
        mq.delay(300)
    end
    return true
end

-- ============================================================ 

function Main()
    if (LootMyCorpse() == true) then 
        return true 
    end

    if (mq.TLO.Window('BigBankWnd').Open() == true) then
        return BigBankWnd()
    end

    if (mq.TLO.Window('MerchantWnd').Open() == true) then
        return MerchantWnd()
    end

    if (mq.TLO.Window('TributeMasterWnd').Open() == true) then
        return TributeMasterWnd()
    end

    if (mq.TLO.Window('TradeWnd').Open() == true) then
        return TradeWnd()
    end

    if (mq.TLO.Window('GiveWnd').Open() == true) then
        return GiveWnd()
    end

    if (LootCorpse() == true) then 
        return true 
    end

    if (GroundGrab() == true) then 
         return true 
    end

    AutoInventory()
end

-- ============================================================ 

Main()