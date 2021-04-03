const fs = require("fs");

const configs = require("./config");
const args = process.argv.slice(2);

function extractCardsFrom(board, cards) {
  let id = 0;
  for (let i = 0; i < board.length; i++) {
    console.log(`${board[i].count} ${board[i].card_digest.name}`);

    id++;
    for (let count = 0; count < board[i].count; count++) {
      cards.ContainedObjects.push({
        CardID: id * 100,
        Name: "Card",
        Nickname: board[i].card_digest.name,
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
      cards.DeckIDs.push(id * 100);
    }

    cards.CustomDeck[id.toString()] = {
      FaceURL: board[i].card_digest.image_uris.front.split("?")[0],
      BackURL: configs.mtgback,
      NumHeight: 1,
      NumWidth: 1,
      BackIsHidden: true
    };
  }
}

if (args.length > 0) {
  console.log(`Importing deck ${args[0]}...`);
  const scryfall = JSON.parse(fs.readFileSync(args[0], "utf8"));

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
      },
      {
        Name: "DeckCustom",
        ContainedObjects: [],
        DeckIDs: [],
        CustomDeck: {},
        Transform: {
          posX: 3,
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

  console.log(scryfall.name);

  if (scryfall.entries && scryfall.entries.mainboard) {
    console.log("=== MAIN ===");
    extractCardsFrom(scryfall.entries.mainboard, tts.ObjectStates[0]);
  }

  if (scryfall.entries && scryfall.entries.sideboard) {
    console.log("=== SIDE ===");
    extractCardsFrom(scryfall.entries.sideboard, tts.ObjectStates[1]);
  }

  fs.writeFileSync(`./${scryfall.name}.json`, JSON.stringify(tts), "utf8");
}
