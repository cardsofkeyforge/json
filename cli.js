const program = require("commander");
const chalk = require("chalk");

const fs = require("fs");
const ejs = require("ejs");

const packageJson = require("./package.json");
const deckApi = require("./deck");
const configs = require("./config");

const version = packageJson.version;

async function processingDeck(deckId) {
  return Promise.resolve(
    await deckApi.retrieveDeck(deckId, configs.lang, false)
  );
}

const importDeck = function(deckId, options) {
  console.info(
    chalk.blue(
      `Import deck: ${deckId} with ${
        options.cockatrice ? "cocatrice" : "standard"
      } output`
    )
  );
  if (options.cockatrice) {
    processingDeck(deckId).then(deck => {
      const expansion = configs.expansion.find(
        e => e.code === deck.data.expansion
      );
      const jsons = "./json/" + expansion.lang + "/" + expansion.name + "/";
      let n = 0;
      let c = "";
      const xmlCards = [];
      deck.data.cards.forEach(cardId => {
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
          id: deck.data.id,
          name: deck.data.name,
          cards: xmlCards
        },
        { filename: deckId },
        function(err, str) {
          if (!err) console.info(chalk.blue(str));
        }
      );
    });
  } else {
    processingDeck(deckId).then(deck =>
      console.info(chalk.blue(JSON.stringify(deck)))
    );
  }
};

program
  .version(version)
  .usage("[command] [options]")
  .allowUnknownOption();

program
  .command("import <deck>")
  .description("Import deck")
  .option("-c, --cockatrice", "Cockatrice output")
  .action(importDeck);

program.parse(process.argv);

if (!process.argv.slice(2).length) {
  program.outputHelp();
}
