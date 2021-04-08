const fs = require("fs");

const deckApi = require("./deck");
const configs = require("./config");
const messages = require("./messages");

const houses = messages[configs.lang].houses;
const builder = messages[configs.lang].builder;
const args = process.argv.slice(2);
const sleeve = args.length > 1 ? args[1] : "red";

async function processingDeck(deckId) {
  return Promise.resolve(
    await deckApi.retrieveDeck(deckId, configs.lang, true)
  );
}

function decodeZoomURL(sets, file, lang) {
  for (const cards of Object.entries(sets)) {
    for (const card of Array.from(cards[1])) {
      if (card.front_image === file) {
        return (
          "/media/" +
          lang +
          "/" +
          cards[0] +
          "/" +
          (card.house === null ? "" : card.house.replace(" ", "") + "-") +
          card.card_number +
          (card.card_type === "Creature1" ? "-1" : "") +
          (card.card_type === "Creature2" ? "-2" : "") +
          ".png"
        );
      }
    }
  }

  return file;
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
          scaleX: 1.5,
          scaleY: 1,
          scaleZ: 1.5
        }
      }
    ]
  };

  const sets = {};
  configs.expansion.forEach(expansion => {
    console.log("Loading cards from " + expansion.longname + "...");
    const cardsFolder = "./json/" + expansion.lang + "/" + expansion.name + "/";
    const cards = fs.readdirSync(cardsFolder);
    console.log("Setup to processing " + cards.length + " cards...");
    const set = [];
    cards.forEach(file => {
      let card = JSON.parse(fs.readFileSync(cardsFolder + file).toString());
      set.push(card);
    });
    sets[expansion.name] = set;
  });

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
          FaceURL:
            configs.zoom + decodeZoomURL(sets, card.front_image, configs.lang),
          BackURL: configs.kfback.replace("{0}", sleeve),
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
