const fs = require("fs");
const ejs = require("ejs");

const configs = require("./config");
const json = require("./decks");
const deckApi = require("./deck");

function sleep(millis) {
  return new Promise(resolve => setTimeout(resolve, millis));
}

function extractCards(id, name, cards, expansion) {
  const jsons = "./json/" + expansion.lang + "/" + expansion.name + "/";
  const deck =
    "./decks/" + expansion.lang + "/" + expansion.name + "/" + name + ".cod";
  console.log("Creating " + deck + "...");

  let n = 0;
  let c = "";
  const xmlCards = [];
  cards.forEach(cardId => {
    const card = JSON.parse(
      fs.readFileSync(jsons + cardId + ".json").toString()
    );
    if (c !== card.card_title && n > 0) {
      xmlCards.push({ number: n, name: c });
      n = 0;
    }

    c = card.card_title;
    n++;
  });
  xmlCards.push({ number: n, name: c });

  ejs.renderFile(
    "./decks/deck.ejs",
    {
      id: id,
      name: name,
      cards: xmlCards
    },
    { filename: deck },
    function(err, str) {
      if (!err) fs.writeFileSync(deck, str, { flag: "w" });
    }
  );
}

async function processingDecks() {
  for (let i = 0; i < json.length; i++) {
    try {
      // eslint-disable-next-line no-await-in-loop
      const deck = await deckApi.retrieveDeck(json[i], configs.lang, false);
      console.log(deck.data.name);
      extractCards(
        deck.data.id,
        deck.data.name,
        deck.data.cards,
        configs.expansion.find(e => e.code === deck.data.expansion)
      );
      // eslint-disable-next-line no-await-in-loop
      await sleep(12000);
    } catch (error) {
      console.error("[" + i + "] Invalid status code " + error);
      if (error === 429) break;
    }
  }
}

// Noinspection JSUnresolvedVariable
console.log("Setup to processing " + json.length + " decks...");
processingDecks().then(() => console.log("Done!"));
