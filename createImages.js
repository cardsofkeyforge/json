const fs = require("fs");

const configs = require("./config");
const imageApi = require("./image");

async function createImage(cards, expansion) {
  for (let i = 0; i < cards.length; i++) {
    const card = cards[i];
    const cardImage =
      "./media/" +
      expansion.lang +
      "/" +
      expansion.name +
      "/" +
      (card.house === null ? "" : card.house.replace(" ", "") + "-") +
      card.card_number +
      (card.card_type === "Creature1" ? "-1" : "") +
      (card.card_type === "Creature2" ? "-2" : "") +
      ".png";

    let response = "[ERROR]";
    let cardUrl = card.front_image;
    const langRE = new RegExp(expansion.lang, "g");
    while (response === "[ERROR]") {
      // eslint-disable-next-line no-await-in-loop
      response = await imageApi.retrieveImage(cardUrl, cardImage);
      if (response === "[ERROR]") {
        cardUrl = card.front_image.replace(langRE, "en");
      }
    }

    console.log(cardUrl);
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
  createImage(set, expansion).then(() =>
    console.log(expansion.longname + " done!")
  );
});
