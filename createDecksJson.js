const fs = require("fs");

const configs = require("./config");
const deckApi = require("./deck");

function sleep(millis) {
  return new Promise(resolve => setTimeout(resolve, millis));
}

function extractDecks(decks) {
  decks.forEach(deck => {
    fs.appendFileSync("decks.json", `"${deck.id}",\n`);
  });
}

async function processingDecks(expansion) {
  for (let page = 1; page <= 40; page++) {
    try {
      // eslint-disable-next-line no-await-in-loop
      const decks = await deckApi.retrieveDecks(
        expansion.code,
        expansion.lang,
        page
      );
      console.log(`Page: ${page}`);
      extractDecks(decks.data);
      // eslint-disable-next-line no-await-in-loop
      await sleep(12000);
    } catch (error) {
      console.error("[" + page + "] Invalid status code " + error);
      if (error === 429) break;
    }
  }
}

configs.expansion.forEach(expansion => {
  console.log("Importing decks from " + expansion.longname + "...");
  processingDecks(expansion).then(() => console.log("Done!"));
});
