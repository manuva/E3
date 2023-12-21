-- Get access to MQ functionality
local mq = require('mq')
-- List of spawns to check
local spawnsToCheck = {"Oogah", "Slushie", "Bussin"}

local function isMoving()
    return mq.TLO.Me.Moving()
end

local function getRace(spawnName)
    return mq.TLO.Spawn(spawnName).Race()
end

local function castProjectIllusion()
    return mq.cmd("/aa act Project Illusion")
end

-- Function to get the current time
local function getCurrentTime()
    return os.time()
end

local function getCurrentTime12h()
    local currentTime12h = os.time()
    return os.date("%I:%M:%S %p", currentTime12h)
end

local function getCombatState()
    return mq.TLO.Me.CombatState()
end

local function castIllusionSpell()
    return mq.cmd('/queuecast Bigcarl "Illusion: Halfling"')
end



while true do

    local timestamp = getCurrentTime()

        for _, spawnName in ipairs(spawnsToCheck) do
            local spawnRace = getRace(spawnName)
            print(spawnName .. "'s race: " .. spawnRace)

            if spawnRace == "Halfling" then
                print(spawnName .. " is a Halfling! No need to cast " .. timestamp)
            else
                -- spawn is not a Halfling, make them one.
                print("not a Halfling")
                if getCombatState() == "ACTIVE" or getCombatState() == "COOLDOWN" or getCombatState == "DEBUFFED"  then
                    print("<<<combat is active. CASTING ILLUSION>>>")
                    castProjectIllusion()
                    mq.cmd("/target " .. spawnName)
                    castIllusionSpell()
                end
            end
        end
        mq.delay(30000)
end
