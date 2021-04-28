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
    const cardName = `${card.card_title}${
      card.rarity === "Evil Twin" ? " (GM)" : ""
    }`;
    if (!keyforge[cardName]) keyforge[cardName] = [];
    if (!set[expansion.name][cardName]) {
      set[expansion.name][cardName] = [];
    }

    keyforge[cardName].push(card);
    set[expansion.name][cardName].push(card);
  });
  console.log(Object.keys(set[expansion.name]).length + " different cards!");
});

console.log(
  `KeyForge has ${Object.keys(keyforge).length} total different cards!`
);
