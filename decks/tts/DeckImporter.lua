buttonColor = {0.19,0.24,0.35,1}
DECK_LIST_INDEX = 1
card_back_options = {"Vermelho", "Azul","Preto"}
language_options = {"Português"}
expansion_options = {"Qualquer", "O Chamado dos Arcontes", "Era da Ascensão", "Colisão entre Mundos", "Mutação em Massa", "Mar de Trevas"}
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
    local expansion = 'Qualquer'
    for _, button in pairs(self.getButtons()) do
        if button.tooltip == "Selecione um Conjunto" then
            expansion = button.label
        end
    end
    Player[player_color].broadcast("Importando um baralho aleatório, aguarde.")
    WebRequest.get("https://api.cardsofkeyforge.com/decks/random/"..expansion, function(request)
        if request.is_error then
            log(request.error)
        else
            if request.is_done then
                for _, input in pairs(self.getInputs()) do
                    if input.label == "ID do Baralho" then
                        self.editInput({index=input.index, value=request.text})
                        FetchDeck(_obj, player_color, _alt_click)
                    end
                end
            end
        end
    end)
end

function FetchDeck(_obj, player_color, _alt_click)
    removeOptions()
    local sleeve = 'Vermelho'
    for _, button in pairs(self.getButtons()) do
        if button.tooltip == "Selecione um Sleeve" then
            sleeve = button.label
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
    WebRequest.get("https://api.cardsofkeyforge.com/decks/tts/"..sleeve.."/"..deckid, function(request)
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
                    end
                })
                if #responseData.ObjectStates > 1 then
                    spawnObjectJSON({
                        json = JSON.encode(responseData.ObjectStates[2]),
                        callback_function = function(deck)
                            local deckZone = getObjectFromGUID(player_decklist[player_color])
                            deck.setPosition(deckZone.getPosition())
                        end
                    })
                end

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
