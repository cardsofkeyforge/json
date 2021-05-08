FIRST_KEY_D8_GUI = '749912'
SECOND_KEY_D8_GUI = 'c81962'
THIRD_KEY_D8_GUI = 'fc06ed'
BAG_D8_GUI = 'ee9f87'

FIRST_KEY_D9_GUI = 'f3e7e0'
SECOND_KEY_D9_GUI = 'ea0cc8'
THIRD_KEY_D9_GUI = 'ac746c'
BAG_D9_GUI = 'bdac35'

ZoneTextTable = {}

starterPlayer = 1

function onload()
    ZoneTextTable['b0c3e3'] = '07299c'
    ZoneTextTable['f36830'] = '565e9e'

    browserWhite = spawnObject({
        type = "Tablet",
        position = {25, 3, -27},
        rotation = {0, 180, 0},
        scale = {1, 1, 1},
        sound = false,
        callback_function = function(browser)
            browser.Browser.url = "https://site.cardsofkeyforge.com"
        end
    })

    browserGreen = spawnObject({
        type = "Tablet",
        position = {-25, 3, 27},
        rotation = {0, 0, 0},
        scale = {1, 1, 1},
        sound = false,
        callback_function = function(browser)
            browser.Browser.url = "https://site.cardsofkeyforge.com"
        end
    })
end

function onPlayerConnect(player)
    if not player.host then
        starterPlayer = math.random(2)
        if starterPlayer == 1 then
            Player['White'].broadcast("Você começa a partida!")
            Player['Green'].broadcast("Você jogará em segundo!")
        else
            Player['White'].broadcast("Você jogará em segundo!")
            Player['Green'].broadcast("Você começa a partida!")
        end
    end
end

function updateEmeraldCounter(zone)
    -- Get objects
    zoneObjects = zone.getObjects()
    local number = 0
    -- Loop through, if its Æmeralds then add it up
    for k,v in pairs(zoneObjects) do
        if v.getName() == 'Æmerald' then
            number = number + 1
        end
    end
    return number;
end

function onObjectEnterScriptingZone(zone, enter_object)
    -- Check if Æmber, call Æmeralds update method
    if enter_object.getName() == 'Æmerald' then
        number = updateEmeraldCounter(zone)
        CountingText = getObjectFromGUID(ZoneTextTable[zone.getGUID()])
        -- Some zones don't have counters, so may be nil
        if CountingText != nil then
            CountingText.setValue('Fichas de Æmber: ' .. number)
        end
    end
end

function onObjectLeaveScriptingZone(zone, leave_object)
    -- Check if Æmeralds, call Æmeralds update method
    if leave_object.getName() == 'Æmerald' then
        number = updateEmeraldCounter(zone)
        CountingText = getObjectFromGUID(ZoneTextTable[zone.getGUID()])
        -- Some zones don't have counters, so may be nil
        if CountingText != nil then
            CountingText.setValue('Fichas de Æmber: ' .. number)
        end
    end
end