-- Get access to MQ functionality
local mq = require('mq')

-- Function to check for movement
local function isMoving()
    return mq.TLO.Me.Moving()
end

-- Function to get the Xtarget count 
local function getXTargetCount()
    return mq.TLO.Me.XTarget()
end

-- Function to get the combat state
local function getCombatState()
    return mq.TLO.Me.CombatState()
end

-- Function to get the current time
local function getCurrentTime()
    return os.time()
end

local function getCurrentTime12h() 
    local currentTime12h = os.time()
    return os.date("%I:%M:%S %p", currentTime12h)
end

-- Define a local function which prints a formatted string with the script name and a message:
local function message(message)
    printf(message)
end

local function ClearTargets()
    mq.cmd("/cleartarget /all")
    return mq.cmd("/e3bct nocap /cleartarget /all")
end 

local function ComeToMeCommand()
    print("-Other players NAVing to me-")
    return mq.cmd("/e3bcg /nav id ${Me.ID}")
end

local function GroupFollowMeCommand()
    print("-Other group members are now following-")
    return mq.cmd("/followme")
end

local function TargetNearestEnemy()
    --test.equal(Me.NearestSpawn('radius 0 pc')(), Me.CleanName())
    local nearestSpawn = mq.cmd('/tar ${NearestSpawn[npc radius 100 "vampyre"]}')
    return nearestSpawn
end

local function Attack()
    mq.cmd("/attack")
end






-- Main loop
local startTime = getCurrentTime()  -- Store the start time
local idleTimeThreshold = 180  -- 3 minutes in seconds
local clearTargetInterval = 8  -- Clear target command interval in seconds
local lastMovementTime = startTime  -- Initialize last movement time
local xTargetIdleThreshold = 30 -- 30 seconds
local xTargetTimer = 0 -- Timer for tracking time with xtargets



while true do


    Attack()

    -- Check for movement
    local moving = isMoving()
    local XTargetCount = getXTargetCount()
    local CombatStatus = getCombatState()

    -- Calculate elapsed time since last movement
    local currentTime = getCurrentTime()
    local elapsedTime = currentTime - lastMovementTime

    -- Timestamp
    local timestamp = getCurrentTime12h()


    print("-Number of targets: " .. XTargetCount)
    print("-Combat Status: " .. CombatStatus)
    print("-Time Elapsed: " .. elapsedTime .. " seconds" .. " (" .. timestamp .. ")" )

    if moving then
        print("-Player is moving. Timers reset")
        lastMovementTime = currentTime  -- Update last movement time
        xTargetTimer = 0 -- reset timer for xtarget checking
    else
        print("-Player is stopped. (5s tick).")
        xTargetTimer = xTargetTimer + 5 --increment by 5
        --print("-- " .. xTargetTimer)
    end


    if elapsedTime >= idleTimeThreshold then
        -- Player has been idle for 3 minutes, issue /cleartarget /all every 5 seconds
        print(" >Player has been idle for 3 minutes. Clearing targets. (" .. timestamp .. ")")
        --mq.command("/cleartarget /all")
        --ClearTargets()
        --Attack()
        mq.delay(clearTargetInterval * 1000)  -- Convert seconds to milliseconds
        GroupFollowMeCommand()
    else
        --mq.delay(3000)  -- Pause for 2 seconds before the next iteration
    end

    if XTargetCount >= 1 then
        ClearTargets()
    end

    --todo
    --target nearest enemy and tag it


    -- check for xtargets while afk
    --- if past set threshold and there are mobs present
    if elapsedTime >= xTargetIdleThreshold and XTargetCount >= 1 then
        print("More than 30 seconds afk and targets found. Fighting!")
        print("Targets found. Fighting!")
        ClearTargets()
        mq.delay(clearTargetInterval * 1000)
    else
        mq.delay(8000)
    end
        --print(">Player has been stopped for " .. xTargetTimer .. "seconds. Monitoring targets and combat")
        --ClearTargets() 
        --xTargetTimer = 0
        --player has been stopped for 30 seconds (threshold)



    if CombatStatus == "ACTIVE" then
        TargetNearestEnemy()
        --cast on target
        mq.cmd("/cast Spear of Disease")
        Attack()
    else
    end
end
