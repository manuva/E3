-- Get access to MQ functionality
local mq = require('mq')
-- List of spawns to check
local spawnsToCheck = {"Jode", "Slushie", "Bussin", "Nocap"}

local function isMoving()
    return mq.TLO.Me.Moving()
end

local function getRace(spawnName)
    return mq.TLO.Spawn(spawnName).Race()
end

local function castProjectIllusion()
    return mq.cmd("/aa act Project Illusion")
end

local function getCurrentTime12h()
    local currentTime12h = os.time()
    return os.date("%I:%M:%S %p", currentTime12h)
end

local function getCombatState()
    return mq.TLO.Me.CombatState()
end

local function castIllusionSpell()
    return mq.cmd('/nowcast Bigcarl "Illusion: Ogre"')
end

while true do
    local timestamp = getCurrentTime12h()
        for _, spawnName in ipairs(spawnsToCheck) do
            local spawnRace = getRace(spawnName)
            print(spawnName .. "'s race: " .. spawnRace)

            if spawnRace == "Ogre" then
                print(spawnName .. " is a ogre! No need to cast " .. timestamp)
            else
                -- spawn is not a gnome, make them one.
                print("not a Ogre")
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
