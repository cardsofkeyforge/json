const fs = require("fs");

const configs = require("./config");

const keyforge = {};
const set = {};
configs.expansion
  .filter(expansion => expansion.name !== "")
  .forEach(expansion => {
    console.log("Loading cards from " + expansion.longname + "...");
    const decks = JSON.parse(
      fs.readFileSync(`./collection/${expansion.name}.json`).toString()
    );
    const cards = decks._linked.cards;
    console.log("Setup to processing " + cards.length + " cards...");
    set[expansion.name] = {};
    cards
      .filter(card => card.house !== "")
      .filter(card => !card.is_maverick && card.expansion === expansion.code)
      .forEach(card => {
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
