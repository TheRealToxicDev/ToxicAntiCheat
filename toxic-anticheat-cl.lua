ESX = nil
Citizen.CreateThread(function()
    while true do
        Wait(5)
        if ESX ~= nil then

        else
            ESX = nil
            TriggerEvent(`esx:getSharedObject`, function(obj) ESX = obj end)
        end
    end
end)

ToxicAntiCheat = true
ToxicAntiCheatStatus = "~g~Active"
PedStatus = 0
whitelisted = false
whitelistCheck = true

--[[ WHITELIST CHECK ]]--
Citizen.CreateThread(fucntion()
while whitelistCheck == true do
    Citizen.Wait( 1000 )
    if ESX.IsPlayerLoaded(PlayerId) then
        TriggerServerEvent('ToxicAntiCheat:Whitelist', GetPlayerServerId(PlayerId()))
        whitelistCheck = false
       end
    end
end)

RegisterNetEvent('ToxicAntiCheat:WLReturn')
AddEventHandler('ToxicAntiCheat:WLReturn', function(wlstatus)
    
    whitelisted = wlstatus
    if whitelisted == true then
        print('[ToxicAntiCheat] Player is whitelisted')
    else
        print('[ToxicAntiCheat] Player is not whitelisted')
    end

end)

--[[ BLACKLISTED CAR CHECK ]]--
Citizen.CreateThread(function()
    while true do
        Wait(500)
        if (ToxicAntiCheat == true and whitelisted == false and whitelistCheck == false)then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                v = GetVehiclePedIsIn(playerPed, false)
            end
            playerPed = GetPlayerPed(-1)

            if playerPed and v then
                if GetPedInVehicleSeat(v, -1) == playerPed then
                    checkCar(GetVehiclePedIsIn(playerPed, false))
                end
            end
        end
    end
end)

--[[ BLACKLISTED WEAPON CHECK ]]--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if (ToxicAntiCheat == true and whitelisted == false and whitelistCheck == false)then
            for _,theWeapon in ipairs(Config.WeaponBL) do
                Wait(1)
                if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
                    RemoveAllPedWeapons(PlayerPedId(),false)
                end
            end
        end
    end
end)

--[[ BLACKLISTED OBJECT CHECK ]]--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ped = PlayerPedId()
        local handle, object = FindFirstObject()
        local finished = false
        repeat
            Wait(1)
            if (ToxicAntiCheat == true and whitelisted == false and whitelistCheck == false)then
                if IsEntityAttached(object) and DoesEntityExist(object) then

                    if GetEntityModel(object) == GetHashKey("prop_acc_guitar_01") then
                        DeleteObjects(object, true)
                    end
                end
            for i=1#Config.ObjectsBL do
                if GetEntityModel(object) == GetHashKey(Config.ObjectsBL[i]) then
                    DeleteObjects(object, false)

                end
            end 
        end
        finished, object = FindNextObject(handle)

    until not finished
    EndFindObject(handle)
   end
end)

--[[ SUPERJUMP CHECK ]]--
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if (ToxicAntiCheat == true and whitelisted == false and whitelistCheck == false)then
            IsPedJumping(PlayerPedId()) then
                local firstCoord = GetEntityCoords(GetPlayerPed(-1))
                while IsPedJumping(PlayerPedId()) do
                    Wait (0)
                end
                local secondCoord = GetEntityCoords(GetPlayerPed(-1))
                local jumplenght = GetDistanceBetweenCoords(firstCoord, secondCoord, false)
                if jumplength > 10.0 then
                    print('[ToxicAntiCheat] You triggered SuperJump')
                    TriggerServerEvent('ToxicAntiCheat:Jump, jumplength')
                end
            end
        end
    end
end)

function DeleteObjects(object, detach)
    if (ToxicAntiCheat == true)then
        if DoesEntityExist(object) then
            NetworkRequestControlOfEntity(object)
            while not NetworkHasControlOfEntity(object) do
                Citizen.Wait(1)
            end
            if detach then
                DetachEntity(object, 0, false)
            end
            
            SetEntityCollision(object, false, false)
            SetEntityAlpha(object, 0.0, true)
            SetEntityAsMissionEntity(object, true, true)
            SetEntityAsNoLongerNeeded(object)
            DeleteEntity(object)
        end
    end
end

function Initialize(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString(anticheatm)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if anticheatm then
            scaleform = Initialize("mp_big_message_freemode")
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        end
    end
end)

RegisterNetEvent('ToxicAntiCheat:Toggle')
AddEventHandler('ToxicAntiCheat:Toggle', function()
    if (ToxicAntiCheat == false) then
        ToxicAntiCheat = true
        ToxicAntiCheatStatus = "~g~Active"
        anticheatm = "~y~ToxicAntiCheat ~g~Enabled"
        Citizen.Wait(5000)
        anticheatm = false
    else
        ToxicAntiCheat = false
        ToxicAntiCheatStatus = "~r~Inactive"
        anticheatm = "~y~ToxicAntiCheat ~r~Disabled"
        PedStatus = "OFF"
        Citizen.Wait(5000)
        anticheatm = false
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        killAllPeds()
        DeleteEntity(ped)
    end
end)

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
  
function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
  
function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	
	return result
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
        if (ToxicAntiCheat == true)then
            thePeds = EnumeratePeds()
            PedStatus = 0
            for ped in thePeds do
                PedStatus = PedStatus + 1
                if PedStatus >= Config.PedThreshold then
                    if not (IsPedAPlayer(ped))then
                        DeleteEntity(ped)
                        RemoveAllPedWeapons(ped, true)
                    end
                end
            end
        end
    end
end)

function TACstatus(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponent(text)
    DrawText(x, y)
end

Citizen.CreateThread( function()
    while true do
        Wait( 0 )
        if whitelisted == true then
            rgb = RGBRainbow(2)
            TACstatus(0.19, 0.88, 1.0,1.0,0.4, "ToxicAntiCheat: "..ToxicAntiCheatStatus, rgb.r, rgb.g, rgb.b, 255, 200)
            TACstatus(0.19, 0.88 + 0.03, 1.0,1.0,0.35, "NPCs: ~r~"..PedStatus, 255, 255, 255, 200)

        end
    end
end)

function KillAllPeds()
    local pedweapon
    local pedid
    for ped in EnumeratePeds() do 
        if DoesEntityExist(ped) then
            pedid = GetEntityModel(ped)
            pedweapon = GetSelectedPedWeapon(ped)
            if (ToxicAntiCheat == true)then
            if pedweapon == -1312131151 or not IsPedHuman(ped) then 
                ApplyDamageToPed(ped, 1000, false)
                DeleteEntity(ped)
            else
                switch = function (choice)
                    choice = choice and tonumber(choice) or choice
                  
                    case =
                    {
                        [451459928] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,
                  
                        [1684083350] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,

                        [451459928] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,
              
                        [1096929346] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,

                        [880829941] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,
          
                        [-1404353274] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,

                        [2109968527] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,

                       default = function ( )
                       end,
                    }

                    if case[choice] then
                       case[choice]()
                    else
                       case["default"]()
                    end
                  
                  end
                  switch(pedid) 
            end
        end
        end
    end
end

function checkCar(car)
    if car then
        carModel = GetEntityModel(car)
        carName = GetDisplayNameFromVehicleModel(carModel)
        if (ToxicAntiCheat == true)then
            if isCarBlacklisted(carModel) then
                _DeleteEntity(car)
                TriggerServerEvent('ToxicAntiCheat:Cars',carName )
            end
        end
    end
end

function isCarBlacklisted(model)
    for _, blacklistedCar in pairs(Config.CarsBL) do
        if model == GetHashKey(blacklistedCar) then
            return true
        end
    end
    return false
end

function _DeleteEntity(entity)
    Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(entity))
end