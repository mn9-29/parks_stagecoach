local QRCore = exports['qr-core']:GetCoreObject()

RegisterServerEvent("parks_stagecoach:pay_fare")
AddEventHandler("parks_stagecoach:pay_fare", function (fare)
	local _src = source
    local Player = QRCore.Functions.GetPlayer(_src)
    Player.Functions.AddMoney("cash", fare, "stagecoach")
end)

-- ADD WAGONE BLIP FOR COACHES TO ALL PLAYERS
RegisterServerEvent("parks_stagecoach:SendDriverEntity")
AddEventHandler("parks_stagecoach:SendDriverEntity", function (coach_driver)
    local _src = source
    print('server_coach_driver', coach_driver)
    TriggerClientEvent("parks_stagecoach:AddDriverBlip", -1, coach_driver)
    TriggerClientEvent("QRCore:Notify", _src, 'second text', 'success')

end)

--- DATA BASE QUERIES
local function GetAmmoutStagecoaches( Player_ID, Character_ID )
    local HasStagecoaches = MySQL.Sync.fetchAll( "SELECT * FROM stagecoaches WHERE citizenid = @citizenid AND cid = @cid ", {
        ['citizenid'] = Player_ID,
        ['cid'] = Character_ID
    } )
    print(HasStagecoaches)
    if #HasStagecoaches > 0 then return true end
    return false
end

RegisterServerEvent("parks_stagecoach:buy_stagecoach")
AddEventHandler("parks_stagecoach:buy_stagecoach", function ( args )

    local _src   = source
    local _price = args['Price']
    local _model = args['Model']
    local _name  = args['Name']
    local Player = QRCore.Functions.GetPlayer(_src)
        u_citizenid = Player.PlayerData.citizenid
        u_cid = Player.PlayerData.cid
        u_money = Player.Functions.GetMoney("cash")
    local _resul = GetAmmoutStagecoaches( u_citizenid, u_cid )
        Player.Functions.RemoveMoney("cash", _price, "stagecoach")
    local Parameters = { ['citizenid'] = u_citizenid, ['cid'] = u_cid, ['stagecoach'] = _model, ['name'] = _name }
    MySQL.Async.execute("INSERT INTO stagecoaches ( `citizenid`, `cid`, `stagecoach`, `name` ) VALUES ( @citizenid, @cid, @stagecoach, @name )", Parameters)
        TriggerClientEvent("QRCore:Notify", _src, 'You got a new Stagecoach !', 'success')
        print('New Stagecoach')
        TriggerClientEvent("parks_stagecoach:SpawnWagon", _src, _model)
end)

RegisterServerEvent("parks_stagecoach:loadstagecoach")
AddEventHandler("parks_stagecoach:loadstagecoach", function ( )
    local _src = source
    local Player = QRCore.Functions.GetPlayer(_src)
	    u_citizenid = Player.PlayerData.citizenid
	    u_cid = Player.PlayerData.cid
    local Parameters = { ['citizenid'] = u_citizenid, ['cid'] = u_cid }
    local HasStagecoaches = MySQL.Sync.fetchAll( "SELECT * FROM stagecoaches WHERE citizenid = @citizenid AND cid = @cid ", Parameters )

    if HasStagecoaches[1] then
        local stagecoach = HasStagecoaches[1].stagecoach
        TriggerClientEvent("parks_stagecoach:LoadCoachesMenu", _src, HasStagecoaches, false)
    end
    
end )

RegisterServerEvent("parks_stagecoach:StartCoachJobServer")
AddEventHandler("parks_stagecoach:StartCoachJobServer", function (zone_name, spawn_coach, driving)
    local _src = source
    TriggerClientEvent("parks_stagecoach:StartCoachJob", _src, zone_name, spawn_coach, driving)
end)