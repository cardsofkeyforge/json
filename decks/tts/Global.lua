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

enhacing = false

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

function addBases(card)
    local icon_slots = {"1d0cef", "30446f", "b6c41c", "d670e6", "47ff10"}
    for idx, slot in pairs(icon_slots) do
        local icon = getObjectFromGUID(slot)
        if icon == nil then
            local enhancement = {
                name     = "base",
                url      = "http://cloud-3.steamusercontent.com/ugc/1464184259785885822/7DD6CF3BA2AE6A191EF51096239D9864E47636C4/",
                position = {0.86, 0.4, -0.92 + 0.22 * (idx - 1)},
                rotation = {90, 180, 0},
                scale    = {0.206311762, 0.342105448, 7.89473867},
            }
            card.addDecal(enhancement)
        end
    end
end

function addAembers(card)
    local icon_slots = {"d591be", "77d75d", "0e7a59", "2039d0", "93a356"}
    for idx, slot in pairs(icon_slots) do
        local icon = getObjectFromGUID(slot)
        if icon != nil then
            local enhancement = {
                name     = "Amber",
                url      = "http://cloud-3.steamusercontent.com/ugc/1327949551204024646/6447043575CF9CE0B6A8BBA125CEB37D0441A103/",
                position = {0.8, 0.45, -0.92 + 0.22 * (idx - 1)},
                rotation = {90, 180, 0},
                scale    = {0.23602064, 0.188157976, 4.342106},
            }
            card.addDecal(enhancement)
        end
    end
end

function addCaptures(card)
    local icon_slots = {"27bd99", "ce3cf2", "d28902", "f2e77f", "6d9e6d"}
    for idx, slot in pairs(icon_slots) do
        local icon = getObjectFromGUID(slot)
        if icon != nil then
            local enhancement = {
                name     = "Capture",
                url      = "http://cloud-3.steamusercontent.com/ugc/1327949551204021496/C8DA8AECB454FDD49B9F59600339827FE82C32EE/",
                position = {0.8, 0.45, -0.92 + 0.22 * (idx - 1)},
                rotation = {90, 180, 0},
                scale    = {0.2238137, 0.206972957, 4.776311},
            }
            card.addDecal(enhancement)
        end
    end
end

function addDamages(card)
    local icon_slots = {"6b0c3a", "bc3ca5", "11e5d3", "eb06e7", "173ee5"}
    for idx, slot in pairs(icon_slots) do
        local icon = getObjectFromGUID(slot)
        if icon != nil then
            local enhancement = {
                name     = "Damage",
                url      = "http://cloud-3.steamusercontent.com/ugc/1327949551204023515/9CD61ADB57C87691683808B65F85F3D2FFDE6BEF/",
                position = {0.8, 0.45, -0.92 + 0.22 * (idx - 1)},
                rotation = {90, 180, 0},
                scale    = {0.223114237, 0.227670163, 5.2539463},
            }
            card.addDecal(enhancement)
        end
    end
end

function addDraws(card)
    local icon_slots = {"34ab64", "c46a45", "bfd97d", "01d540", "85b544"}
    for idx, slot in pairs(icon_slots) do
        local icon = getObjectFromGUID(slot)
        if icon != nil then
            local enhancement = {
                name     = "Draw",
                url      = "http://cloud-3.steamusercontent.com/ugc/1327949551204011885/4EFBF9050F2709451F9004F6D3778D0DD15FDFA7/",
                position = {0.8, 0.45, -0.92 + 0.22 * (idx - 1)},
                rotation = {90, 180, 0},
                scale    = {0.196684808, 0.2069729, 4.776312},
            }
            card.addDecal(enhancement)
        end
    end
end

function addEnhancements(card)
    addBases(card)
    addAembers(card)
    addCaptures(card)
    addDamages(card)
    addDraws(card)
end

function onObjectEnterScriptingZone(zone, enter_object)
    if (zone.getName() == 'CardEncoder') then
        if enhacing and enter_object.name == 'Card' then
            addEnhancements(enter_object)
        end

        return
    end

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
    if (zone.getName() == 'CardEncoder') then
        if enhacing and leave_object.name == 'Card' then
            leave_object.flip()
            leave_object.setPosition({zone.getPosition()[1] - 5, zone.getPosition()[2], zone.getPosition()[3]})
        end

        return
    end

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
