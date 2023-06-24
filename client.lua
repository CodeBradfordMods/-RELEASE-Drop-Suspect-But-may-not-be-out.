-- Script Created By Evan Bradford - 06/24/2023

local shotCount = {}
local lastRagdollTime = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        
        
        if HasEntityBeenDamagedByAnyPed(ped) then
            local hit, bone = GetPedLastDamageBone(ped)
            hit = Bool(hit)

            if hit then
                
                if not shotCount[ped] then
                    shotCount[ped] = 1
                else
                    shotCount[ped] = shotCount[ped] + 1
                end

                local randomShots = math.random(3, 7)

                if shotCount[ped] >= randomShots then
                    Disarm(ped)
                end
            end
        else

            if not lastRagdollTime[ped] then
                lastRagdollTime[ped] = GetGameTimer()
            elseif shotCount[ped] and (GetGameTimer() - lastRagdollTime[ped]) > 20000 then
                shotCount[ped] = 0
                lastRagdollTime[ped] = nil
            end
        end

        ClearEntityLastDamageEntity(ped)
    end
end)

function Bool(num)
    return num == 1 or num == true
end

function Disarm(ped)
    if IsEntityDead(ped) then
        return false
    end

    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    local boneCoords = GetPedBoneCoords(ped, GetEntityBoneIndexByName(ped, "IK_Head"))
    SetPedToRagdoll(ped, 7000, 7000, 0, 0, 0, 0)
    shotCount[ped] = 0 
    lastRagdollTime[ped] = GetGameTimer()

    return true
end

Citizen.CreateThread(function()
    while true do
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPISTOL"), 0.48)
        Citizen.Wait(0)
    end
end)
