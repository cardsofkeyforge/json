const fs = require("fs");

const configs = require("./config");

const keyforge = {};
const set = {};
configs.expansion.forEach(expansion => {
  console.log("Loading cards from " + expansion.longname + "...");
  const cardsFolder = "./json/" + expansion.lang + "/" + expansion.name + "/";
  const cards = fs.readdirSync(cardsFolder);
  console.log("Setup to processing " + cards.length + " cards...");
  set[expansion.name] = {};
  cards.forEach(file => {
    let card = JSON.parse(fs.readFileSync(cardsFolder + file).toString());
    if (!keyforge[card.card_title]) keyforge[card.card_title] = [];
    if (!set[expansion.name][card.card_title]) {
      set[expansion.name][card.card_title] = [];
    }

    keyforge[card.card_title].push(card);
    set[expansion.name][card.card_title].push(card);
  });
  console.log(Object.keys(set[expansion.name]).length + " different cards!");
});

console.log(
  `KeyForge has ${Object.keys(keyforge).length} total different cards!`
);
