FIRST_KEY_D8_GUI = '749912'
SECOND_KEY_D8_GUI = 'c81962'
THIRD_KEY_D8_GUI = 'fc06ed'
BAG_D8_GUI = 'ee9f87'

FIRST_KEY_D9_GUI = 'f3e7e0'
SECOND_KEY_D9_GUI = 'ea0cc8'
THIRD_KEY_D9_GUI = 'ac746c'
BAG_D9_GUI = 'bdac35'

ZoneTextTable = {}

function onload()
    ZoneTextTable['b0c3e3'] = '07299c'
    ZoneTextTable['f36830'] = '565e9e'
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
end--