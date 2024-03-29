buttonColor = {0.19,0.24,0.35,1}
DECK_LIST_INDEX = 1
card_back_options = {"Vermelho", "Azul", "Roxo", "Preto"}
language_options = {"Português"}
expansion_options = {"Qualquer", "O Chamado dos Arcontes", "Era da Ascensão", "Colisão entre Mundos", "Mutação em Massa", "Mar de Trevas", "Troca de Ares", "Ascensão de Keyraken", "A Conspiração Abissal"}
player_draw = { White = '2a72b5', Green = '354143' }
player_decklist = { White = '5536f1', Green = '5e3694' }

function onLoad()
    self.setName("Painel de Importação")
    --Random Buttom
    self.createButton({
        click_function="selectRandomDeck",
        function_owner=self,
        position={0.33, 0.65, -1},
        height=400, width=1200,
        color=buttonColor,
        font_color={1,1,1,1},
        font_size=140,
        label="ALEATÓRIO"
    })
    --Build Deck Buttom
    self.createButton({
        click_function="FetchDeck",
        function_owner=self,
        position={0.33, 0.65,-3.8},
        height=400, width=1200,
        color=buttonColor,
        font_color={1,1,1},
        font_size=120,
        label="IMPORTAR"
    })
    --Build CardBack Button
    self.createButton({
        click_function="createCardBackDropDown",
        function_owner=self,
        position = {-3.43, 0.65, 1.6},
        height=400, width=1200,
        color=buttonColor,
        font_color={1,1,1},
        font_size=150,
        label="Vermelho",
        tooltip="Selecione um Sleeve",
    })
    --Build Language Button
    self.createButton({
        click_function="createLanguageDropDown",
        function_owner=self,
        position = {0.33, 0.65, 1.6},
        height=400, width=1200,
        color=buttonColor,
        font_color={1,1,1},
        font_size=150,
        label="Português",
        tooltip="Selecione um Idioma",
    })
    --Build Expansion Button
    self.createButton({
        click_function="createExpansionDropDown",
        function_owner=self,
        position = {-5.6, 0.65, -1},
        height=400, width=1800,
        color=buttonColor,
        font_color={1,1,1},
        font_size=150,
        label="Qualquer",
        tooltip="Selecione um Conjunto",
    })
    --deckURL
    self.createInput({
        input_function="none",
        function_owner=self,
        label = "ID do Baralho",
        position = {-2.92, 0.648999989032745, -5.07},
        width = 4570, height = 375,
        font_size = 350,
        color = {0.8431, 0.8117, 0.7294, 0.8},
        font_color = {0.4039, 0.0862, 0.0862, 1}
    })
    --DeckList
    self.createInput({
        input_function="none",
        function_owner=self,
        position={5.08, 0.649, -2.83},
        color = {0.8431, 0.8117, 0.7294, 0.8},
        font_color = {0.4039, 0.0862, 0.0862, 1},
        height=4640, width=2490,
        font_size=100,
        label="Cartas do Baralho",
    })
    for _, input in pairs(self.getInputs()) do
        if input.label == "Cartas do Baralho" then DECK_LIST_INDEX = input.index end
    end
end

function selectRandomDeck(_obj, player_color, _alt_click)
    removeOptions()
    self.editInput({index=DECK_LIST_INDEX, value=''})
    local expansion = 'all'
    local expansion_values = {}
    expansion_values["Qualquer"] = "all"
    expansion_values["O Chamado dos Arcontes"] = "cota"
    expansion_values["Era da Ascensão"] = "aoa"
    expansion_values["Colisão entre Mundos"] = "wc"
    expansion_values["Mutação em Massa"] = "mm"
    expansion_values["Mar de Trevas"] = "dt"
    expansion_values["Troca de Ares"] = "woe"
    expansion_values["Ascensão de Keyraken"] = "rotk"
    expansion_values["A Conspiração Abissal"] = "tac"
    for _, button in pairs(self.getButtons()) do
        if button.tooltip == "Selecione um Conjunto" then
            expansion = expansion_values[button.label]
        end
    end
    if expansion == "rotk" then
        FetchRotK(_obj, player_color, _alt_click)
        return
    end
    if expansion == "tac" then
        FetchTAC(_obj, player_color, _alt_click)
        return
    end
    Player[player_color].broadcast("Importando um baralho aleatório, aguarde.")
    WebRequest.get("https://api.cardsofkeyforge.com/decks/random?set="..expansion, function(request)
        if request.is_error then
            log(request.error)
        else
            if request.is_done then
                for _, input in pairs(self.getInputs()) do
                    if input.label == "ID do Baralho" then
                        local vaultDeck = JSON.decode(request.text)
                        Player[player_color].broadcast("Seu baralho será o "..vaultDeck.Name.."!")
                        self.editInput({index=input.index, value=vaultDeck.Id})
                        FetchDeck(_obj, player_color, _alt_click)
                    end
                end
            end
        end
    end)
end

function FetchRotK(_obj, player_color, _alt_click)
    WebRequest.get("https://raw.githubusercontent.com/cardsofkeyforge/json/master/decks/tts/special/Rise%20of%20the%20Keyraken.json", function(request)
        if request.is_error then
            log(request.error)
        else
            if request.is_done then
                local responseData = JSON.decode(request.text)
                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[1]),
                    callback_function = function(deck)
                        local deckZone = getObjectFromGUID(player_draw[player_color])
                        deck.setPosition(deckZone.getPosition())
                        deck.setRotation(deckZone.getRotation())
                    end
                })

                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[3]),
                    callback_function = function(deck)
                        local deckZone = getObjectFromGUID(player_decklist[player_color])
                        deck.setPosition(deckZone.getPosition())
                        deck.setRotation({deckZone.getRotation()[1], deckZone.getRotation()[2], deck.getRotation()[3]})
                    end
                })

                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[2]),
                    callback_function = function(deck)
                        deck.setPosition({0, 1, 0})
                    end
                })

                local deckList = "Cartas do Baralho"
                for _, cardData in pairs(responseData.ObjectStates[1].ContainedObjects) do
                    deckList = deckList.."\n"..cardData.Nickname
                end
                self.editInput({index=DECK_LIST_INDEX, value=deckList})
                Player[player_color].broadcast("Baralho da aventura Ascensão de Keyraken importado!")
            end
        end
    end)
end

function FetchTAC(_obj, player_color, _alt_click)
    WebRequest.get("https://raw.githubusercontent.com/cardsofkeyforge/json/master/decks/tts/special/The%20Abyssal%20Conspiracy.json", function(request)
        if request.is_error then
            log(request.error)
        else
            if request.is_done then
                local responseData = JSON.decode(request.text)
                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[1]),
                    callback_function = function(deck)
                        local deckZone = getObjectFromGUID(player_draw[player_color])
                        deck.setPosition(deckZone.getPosition())
                        deck.setRotation(deckZone.getRotation())
                    end
                })

                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[3]),
                    callback_function = function(deck)
                        local deckZone = getObjectFromGUID(player_decklist[player_color])
                        deck.setPosition(deckZone.getPosition())
                        deck.setRotation({deckZone.getRotation()[1], deckZone.getRotation()[2], deck.getRotation()[3]})
                    end
                })

                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[2]),
                    callback_function = function(deck)
                        local deckZone = getObjectFromGUID(player_decklist[player_color])
                        deck.setPosition(deckZone.getPosition())
                        deck.setPosition({deck.getPosition()[1] - 10, deck.getPosition()[2], deck.getPosition()[3] + 5})
                    end
                })

                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[4]),
                    callback_function = function(deck)
                        local deckZone = getObjectFromGUID(player_decklist[player_color])
                        deck.setPosition(deckZone.getPosition())
                        deck.setPosition({deck.getPosition()[1] - 10, deck.getPosition()[2], deck.getPosition()[3]})
                    end
                })

                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[5]),
                    callback_function = function(deck)
                        local deckZone = getObjectFromGUID(player_decklist[player_color])
                        deck.setPosition(deckZone.getPosition())
                        deck.setPosition({deck.getPosition()[1] - 5, deck.getPosition()[2], deck.getPosition()[3]})
                    end
                })

                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[6]),
                    callback_function = function(deck)
                        local deckZone = getObjectFromGUID(player_decklist[player_color])
                        deck.setPosition(deckZone.getPosition())
                        deck.setPosition({deck.getPosition()[1] - 27.5, deck.getPosition()[2], deck.getPosition()[3] + 3.5})
                    end
                })

                local deckList = "Cartas do Baralho"
                for _, cardData in pairs(responseData.ObjectStates[1].ContainedObjects) do
                    deckList = deckList.."\n"..cardData.Nickname
                end
                self.editInput({index=DECK_LIST_INDEX, value=deckList})
                Player[player_color].broadcast("Baralho da aventura A Conspiração Abissal importado!")
            end
        end
    end)
end

function FetchDeck(_obj, player_color, _alt_click)
    removeOptions()
    local sleeve = 'red'
    local sleeve_values = {}
    sleeve_values["Vermelho"] = "red"
    sleeve_values["Azul"] = "blue"
    sleeve_values["Roxo"] = "purple"
    sleeve_values["Preto"] = "black"
    for _, button in pairs(self.getButtons()) do
        if button.tooltip == "Selecione um Sleeve" then
            sleeve = sleeve_values[button.label]
        end
    end
    local URL = ""
    Player[player_color].broadcast("Importando o seu baralho, aguarde.")
    for _, input in pairs(self.getInputs()) do
        if input.label == "ID do Baralho" then
            URL = input.value
            self.editInput({index=input.index, value=''})
        end
    end
    if not URL or string.len(URL) == 0 then return Player[player_color].broadcast("Por favor, informe o ID do seu baralho.", {1, 1, 1}) end
    local deckid = URL:match("%w+-%w+-%w+-%w+-%w+")
    WebRequest.get("https://api.cardsofkeyforge.com/decks/tts?deckid="..deckid.."&sleeve="..sleeve, function(request)
        if request.is_error then
            log(request.error)
        else
            if request.is_done then
                local responseData = JSON.decode(request.text)
                spawnObjectJSON({
                    json = JSON.encode(responseData.ObjectStates[1]),
                    callback_function = function(deck)
                        local deckZone = getObjectFromGUID(player_draw[player_color])
                        deck.setPosition(deckZone.getPosition())
                        deck.setRotation(deckZone.getRotation())
                    end
                })
                if #responseData.ObjectStates > 1 then
                    spawnObjectJSON({
                        json = JSON.encode(responseData.ObjectStates[2]),
                        callback_function = function(deck)
                            local deckZone = getObjectFromGUID(player_decklist[player_color])
                            deck.setPosition(deckZone.getPosition())
                            deck.setRotation(deckZone.getRotation())
                        end
                    })
                end

                local browser = Global.getVar("browser"..player_color)
                browser.Browser.url = "https://www.keyforgegame.com/deck-details/"..deckid
                local deckList = "Cartas do Baralho"
                for _, cardData in pairs(responseData.ObjectStates[1].ContainedObjects) do
                    deckList = deckList.."\n"..cardData.Nickname
                end
                self.editInput({index=DECK_LIST_INDEX, value=deckList})
                Player[player_color].broadcast("Baralho "..deckid.." importado!")
            end
        end
    end)
end

function createCardBackDropDown()
    removeOptions()
    for x, color in ipairs(card_back_options) do
        self.createButton({
            click_function= dynamicFunction("setColor"..color, function(obj, player, input_value, selected) setCardBack(color) end),
            function_owner=self,position = {-3.43, 0.7, 1.6+(x*0.8)},
            height=400, width=1200,
            color=buttonColor,font_color={1,1,1},
            font_size=150,label=color
        })
    end
end

function setCardBack(color)
    for _, button in pairs(self.getButtons()) do
        if button.tooltip == "Selecione um Sleeve" then
            self.editButton({index=button.index, label=color})
        end
    end
    removeOptions()
end

function createLanguageDropDown()
    removeOptions()
    for x, lang in ipairs(language_options) do
        self.createButton({
            click_function= dynamicFunction("setLang"..lang, function(obj, player, input_value, selected) setLang(lang) end),
            function_owner=self,position = {0.33, 0.7, 1.6+(x*0.8)},
            height=400, width=1200,
            color=buttonColor,font_color={1,1,1},
            font_size=150,label=lang
        })
    end
end

function setLang(lang)
    for _, button in pairs(self.getButtons()) do
        if button.tooltip == "Selecione um Idioma" then
            self.editButton({index=button.index, label=lang})
        end
    end
    removeOptions()
end

function createExpansionDropDown()
    removeOptions()
    for x, expansion in ipairs(expansion_options) do
        self.createButton({
            click_function= dynamicFunction("setExpansion"..expansion, function(obj, player, input_value, selected) setExpansion(expansion) end),
            function_owner=self,position = {-5.6, 0.7, -1+(x*0.8)},
            height=400, width=1800,
            color=buttonColor,font_color={1,1,1},
            font_size=150,label=expansion
        })
    end
end

function setExpansion(expansion)
    for _, button in pairs(self.getButtons()) do
        if button.tooltip == "Selecione um Conjunto" then
            self.editButton({index=button.index, label=expansion})
        end
    end
    removeOptions()
end

function removeOptions()
    for _, button in pairs(self.getButtons()) do
        if button.index > 4 then self.removeButton(button.index) end
    end
end

function dynamicFunction(funcName, func)
  self.setVar(funcName, func)
  return funcName
end

--Dummy function, absorbs unwanted triggers
function none() end
