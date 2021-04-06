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
      ".png";

    // eslint-disable-next-line no-await-in-loop
    console.log(await imageApi.retrieveImage(card.front_image, cardImage));
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
  createImage(set, expansion).then(() => console.log("Done!"));
});
