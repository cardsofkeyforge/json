const fs = require("fs");

const deckApi = require("./deck");
const configs = require("./config");
const messages = require("./messages");

const houses = messages[configs.lang].houses;
const builder = messages[configs.lang].builder;
const args = process.argv.slice(2);

async function processingDeck(deckId) {
  return Promise.resolve(
    await deckApi.retrieveDeck(deckId, configs.lang, true)
  );
}

if (args.length > 0) {
  let tts;
  tts = {
    ObjectStates: [
      {
        Name: "DeckCustom",
        ContainedObjects: [],
        DeckIDs: [],
        CustomDeck: {},
        Transform: {
          posX: 0,
          posY: 1,
          posZ: 0,
          rotX: 0,
          rotY: 180,
          rotZ: 180,
          scaleX: 1,
          scaleY: 1,
          scaleZ: 1
        }
      }
    ]
  };

  processingDeck(args[0]).then(deck => {
    console.log(`Importing deck ${deck.data.name}...`);
    let id = 0;
    let lastCard = "";
    deck.data._links.cards.forEach(uuid => {
      const card = deck._linked.cards.find(c => c.id === uuid);
      console.log(card.card_title);
      if (lastCard !== card.card_title) {
        id++;
        lastCard = card.card_title;
        tts.ObjectStates[0].CustomDeck[id.toString()] = {
          FaceURL: card.front_image,
          BackURL: configs.kfback,
          NumHeight: 1,
          NumWidth: 1,
          BackIsHidden: true
        };
      }

      let description = houses[card.house].name;
      if (card.is_maverick) description += "\n" + builder.Maverick;
      if (card.is_anomaly) description += "\n" + builder.Anomaly;
      if (card.is_enhanced) description += "\n" + builder.Enhanced;
      tts.ObjectStates[0].ContainedObjects.push({
        CardID: id * 100,
        Name: "Card",
        Nickname: card.card_title,
        Description: description,
        Transform: {
          posX: 0,
          posY: 0,
          posZ: 0,
          rotX: 0,
          rotY: 180,
          rotZ: 180,
          scaleX: 1,
          scaleY: 1,
          scaleZ: 1
        }
      });
      tts.ObjectStates[0].DeckIDs.push(id * 100);
    });

    fs.writeFileSync(`./${deck.data.name}.json`, JSON.stringify(tts), "utf8");
  });
}
