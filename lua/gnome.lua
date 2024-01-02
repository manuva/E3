-- Get access to MQ functionality
local mq = require('mq')
-- List of spawns to check
local spawnsToCheck = {"Jode", "Oogah", "Slushie", "Bussin", "Nocap", "Fufanu"}

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
    return mq.cmd('/nowcast Bigcarl "Illusion: Gnome"')
end

while true do

    local moving = isMoving()
    local timestamp = getCurrentTime12h()

        for _, spawnName in ipairs(spawnsToCheck) do
            local spawnRace = getRace(spawnName)
            print(spawnName .. "'s race: " .. spawnRace)

            if spawnRace == "Gnome" then
                print(spawnName .. " is a gnome! No need to cast " .. timestamp)
            else
                -- spawn is not a gnome, make them one.
                print("not a gnome")
                if getCombatState() == "ACTIVE" or getCombatState() == "COOLDOWN" or getCombatState == "DEBUFFED"  then
                    if moving then
                        -- moving
                    else
                        --not moving
                        print("<<<combat is active. CASTING ILLUSION>>>")
                        castProjectIllusion()
                        mq.cmd("/target " .. spawnName)
                        castIllusionSpell() 
                    end
                end
            end
            mq.delay(30000)
        end
        --mq.delay(30000)
end
