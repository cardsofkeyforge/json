const fs = require("fs");

const configs = require("./config");

configs.expansion.forEach(expansion => {
  console.log("Loading cards from " + expansion.longname + "...");
  const cardsFolder = "./json/" + expansion.lang + "/" + expansion.name + "/";
  const cards = fs.readdirSync(cardsFolder);
  console.log("Setup to processing " + cards.length + " cards...");
  const set = {};
  cards.forEach(file => {
    let card = JSON.parse(fs.readFileSync(cardsFolder + file).toString());
    if (!set[card.card_title]) set[card.card_title] = [];
    set[card.card_title].push(card);
  });
  console.log(Object.keys(set).length + " different cards!");
});
