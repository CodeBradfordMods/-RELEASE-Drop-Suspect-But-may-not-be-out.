-- Script Created By Evan Bradford - 06/24/2023

local droppedWeapons = {}

RegisterServerEvent("SyncDroppedWeapon")
AddEventHandler("SyncDroppedWeapon", function(weapon, coords, ammo)
    local pickup = CreateWeaponPickup(weapon, coords, ammo)
    if pickup then
        local weaponData = {
            pickup = pickup,
            coords = coords,
            ammo = ammo,
            timer = 30
        }
        droppedWeapons[weapon] = weaponData
        TriggerClientEvent("AddDroppedWeapon", -1, source, weapon, coords, ammo)
    end
end)

RegisterServerEvent("PickupWeapon")
AddEventHandler("PickupWeapon", function(weapon)
    local _source = source
    local ped = GetPlayerPed(_source)
    
    if not HasPedGotWeapon(ped, GetHashKey(weapon), false) then
        local droppedWeapon = droppedWeapons[weapon]
        
        if droppedWeapon and droppedWeapon.timer > 0 then
            local coords = GetEntityCoords(ped)
            local weaponDistance = #(coords - droppedWeapon.coords)
            
            if weaponDistance <= 2.0 then
                GiveWeaponToPed(ped, GetHashKey(weapon), droppedWeapon.ammo, false, true)
                TriggerClientEvent("RemoveDroppedWeapon", -1, weapon)
                droppedWeapons[weapon] = nil
            else
                TriggerClientEvent("WeaponPickupFailure", _source)
            end
        else
            TriggerClientEvent("WeaponPickupFailure", _source)
        end
    else
        TriggerClientEvent("WeaponPickupFailure", _source)
    end
end)

function CreateWeaponPickup(weapon, coords, ammo)
    local model = GetHashKey(weapon)
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
    
    local pickup = CreatePickupRotate(model, coords.x, coords.y, coords.z - 0.2, 0, 0, 0, 2, ammo, 1, true, model)
    SetEntityRotation(pickup, 0.0, 0.0, 0.0, 2, true)
    SetEntityAsMissionEntity(pickup, true, true)
    
    if DoesPickupExist(pickup) then
        return pickup
    else
        return nil
    end
end
