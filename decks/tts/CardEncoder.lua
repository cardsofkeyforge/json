function onload()
  self.setName("Botão de Propagar")
  self.setDescription("Use este botão para propagar")
  button_parameters = {}
  button_parameters.click_function = 'enhancement'
  button_parameters.function_owner = self
  button_parameters.label = 'Propagar'
  button_parameters.position = { 0, 0.2, 0 }
  button_parameters.rotation = { 0, 180, 0 }
  button_parameters.width = 1400
  button_parameters.height = 500
  button_parameters.font_size = 250
  button_parameters.color={0.19,0.24,0.35,1}
  button_parameters.font_color={1,1,1,1}
  self.createButton(button_parameters)
end

function enhancement()
    if button_parameters.label == 'Propagar' then
        Global.setVar("enhacing", true)
        button_parameters.label = 'Parar'
        button_parameters.color={0.35,0.24,0.19,1}
        self.editButton(button_parameters)

        local find = true
        while find do
            find = getEnhancedCards()
        end

        local enhanceZone = getObjectFromGUID("f1ff65")
        Player["White"].lookAt({
            position = enhanceZone.getPosition(),
            pitch    = 90,
            distance = 10,
        })
    else
        Global.setVar("enhacing", false)
        button_parameters.label = 'Propagar'
        button_parameters.color={0.19,0.24,0.35,1}
        self.editButton(button_parameters)
    end
end

function getEnhancedCards()
    local deckZone = getObjectFromGUID("2a72b5")
    local enhanceZone = getObjectFromGUID("f1ff65")
    for _, obj in ipairs(deckZone.getObjects()) do
        if obj.name == "DeckCustom" then
            for _, card in ipairs(obj.getObjects()) do
                if string.find(card.description, "Propagada") then
                    obj.takeObject({
                        index = card.index,
                        position = {enhanceZone.getPosition()[1] + 5, enhanceZone.getPosition()[2], enhanceZone.getPosition()[3]},
                        rotation = {0, 180, 0}
                    })
                    return true
                end
            end
        end
    end
    return false
end
