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
    mq.cmd("/cleartarget")
    return mq.cmd("/e3bct winnston /cleartarget")
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
    local nearestSpawn = mq.cmd('/tar ${NearestSpawn[npc radius 100 "noc"]}')
    return nearestSpawn
end

local function Attack()
    mq.cmd("/attack")
    mq.cmd("/assistme")
end



-- Main loop
local startTime = getCurrentTime()  -- Store the start time
local idleTimeThreshold = 180  -- 3 minutes in seconds
local clearTargetInterval = 8  -- Clear target command interval in seconds
local lastMovementTime = startTime  -- Initialize last movement time
local xTargetIdleThreshold = 30 -- 30 seconds
local xTargetTimer = 0 -- Timer for tracking time with xtargets



while true do

    mq.cmd("/target Vaporessa")
    mq.cmd("/nowcast Mesmerization")
    mq.delay(5000)

end