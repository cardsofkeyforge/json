const fs = require("fs");

const configs = require("./config");
const rulings = require("./json/pt/rulings");

function createImageData(card, expansion) {
  return {
    id: card.id,
    house: card.house,
    normal: card.front_image,
    zoom:
      configs.zoom +
      "/media/" +
      expansion.lang +
      "/" +
      expansion.name +
      "/" +
      (card.house === null ? "" : card.house.replace(" ", "") + "-") +
      card.card_number +
      (card.card_type === "Creature1" ? "-1" : "") +
      (card.card_type === "Creature2" ? "-2" : "") +
      ".png"
  };
}

function createCards(cards, expansion) {
  const path = "./json/" + expansion.lang + "/" + expansion.name + "/";
  let lastCard = {};
  cards.forEach(card => {
    if (lastCard.card_number === card.card_number) {
      lastCard.houses.push(createImageData(card, expansion));
    } else {
      if (lastCard.card_number !== undefined) {
        delete lastCard.id;
        delete lastCard.house;
        delete lastCard.front_image;
        fs.writeFileSync(
          path + lastCard.card_number + ".json",
          JSON.stringify(lastCard)
        );
      }

      lastCard = card;
      lastCard.houses = [];
      lastCard.houses.push(createImageData(card, expansion));
      lastCard.rules = rulings.filter(rule => rule.cards.includes(card.id));
    }
  });

  if (lastCard.card_number !== undefined) {
    delete lastCard.id;
    delete lastCard.house;
    delete lastCard.front_image;
    fs.writeFileSync(
      path + lastCard.card_number + ".json",
      JSON.stringify(lastCard)
    );
  }
}

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
  set.sort((c1, c2) => String(c1.card_number).localeCompare(c2.card_number));
  createCards(set, expansion);
});