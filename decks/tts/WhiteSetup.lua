FIRST_KEY_GUI = Global.getVar('FIRST_KEY_D8_GUI')
SECOND_KEY_GUI = Global.getVar('SECOND_KEY_D8_GUI')
THIRD_KEY_GUI = Global.getVar('THIRD_KEY_D8_GUI')
BAG_GUI = Global.getVar('BAG_D8_GUI')

function onload()
  self.setName("Botão de Ações")
  self.setDescription("Use este botão para iniciar o jogo e embaralhar")
  button_parameters = {}
  button_parameters.click_function = 'start_setup'
  button_parameters.function_owner = self
  button_parameters.label = 'Iniciar Jogo'
  button_parameters.position = { 0, 0.14, 0 }
  button_parameters.rotation = { 0, 180, 0 }
  button_parameters.width = 1400
  button_parameters.height = 500
  button_parameters.font_size = 250
  self.createButton(button_parameters)
end

function start_setup()
  shuffleDeck()
  setupTable()
end

function shuffleDeck()
  position = self.getPosition()
  local objList = Physics.cast({
      origin=position, type=2, size={5,5,5},
      direction={0,1,0},
      max_distance=1, debug=false
  })

  local foundItems = {}
    for _, obj in ipairs(objList) do
        if obj.hit_object.tag == 'Deck' then
          local object = obj.hit_object
          local rotation = object.getRotation()
          if rotation.z > 175 and rotation.z < 185 then
            print('Embaralhando '..object.getName())
            if (object.getQuantity() == 36) then
                object.randomize()
                Wait.frames(function() object.deal(7, 'White') end, 60)
                button_parameters.label = 'Mulligan'
                self.editButton(button_parameters)
            else
                broadcastToAll('Jogador Branco tomou um mulligan!', {r=1, g=0, b=0})
                object.reset()
                Wait.frames(function() object.randomize() end, 60)
                Wait.frames(function() object.deal(6, 'White') end, 120)
            end
          end
        end
    end

  print('Embaralhado!')
  return 1
end

function setupTable()
    local bag = getObjectFromGUID(BAG_GUI)
    if bag.getQuantity() != 0 then
        bag.takeObject({position={bag.getPosition().x + 2, bag.getPosition().y, bag.getPosition().z + 15}})

        local firstKeyZone = getObjectFromGUID(FIRST_KEY_GUI)
        bag.takeObject({position={firstKeyZone.getPosition().x, firstKeyZone.getPosition().y + 2, firstKeyZone.getPosition().z}, rotation={0, 180, 0}})
        local secondKeyZone = getObjectFromGUID(SECOND_KEY_GUI)
        bag.takeObject({position={secondKeyZone.getPosition().x, secondKeyZone.getPosition().y + 2, secondKeyZone.getPosition().z}, rotation={0, 180, 0}})
        local thirdKeyZone = getObjectFromGUID(THIRD_KEY_GUI)
        bag.takeObject({position={thirdKeyZone.getPosition().x, thirdKeyZone.getPosition().y + 2, thirdKeyZone.getPosition().z}, rotation={0, 180, 0}})
        bag.takeObject({position={thirdKeyZone.getPosition().x + 7, thirdKeyZone.getPosition().y + 2, thirdKeyZone.getPosition().z}, rotation={0, 180, 0}})

        bag.takeObject({position={bag.getPosition().x + 2, bag.getPosition().y, bag.getPosition().z + 19}})
        bag.takeObject({position={bag.getPosition().x + 2, bag.getPosition().y, bag.getPosition().z + 22}})
        bag.takeObject({position={bag.getPosition().x + 2, bag.getPosition().y, bag.getPosition().z + 25}})
        bag.takeObject({position={bag.getPosition().x + 2, bag.getPosition().y, bag.getPosition().z + 28}})
        bag.takeObject({position={bag.getPosition().x + 2, bag.getPosition().y, bag.getPosition().z + 31}})
        bag.takeObject({position={bag.getPosition().x + 2, bag.getPosition().y, bag.getPosition().z + 34}})
    end
    print('O jogo está pronto para iniciar!')
end