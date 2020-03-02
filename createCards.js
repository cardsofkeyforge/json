const fs = require("fs");

const configs = require('./config');
const expansion = configs.expansion[3];
const json = require("./decks");
const deckApi = require("./deck");

function sleep(millis) {
    return new Promise(resolve => setTimeout(resolve, millis));
}

function extractCards(cards) {
    const prefix = './json/' + expansion.lang + '/' + expansion.name + '/';
    // noinspection JSUnresolvedVariable
    cards.filter(card => !card.is_maverick).filter(card => card.expansion === expansion.code)
            .forEach(card => {
                console.log(card.id);
                if (!fs.existsSync(prefix + card.id + '.json')) {
                    fs.writeFileSync(prefix + card.id + '.json', JSON.stringify(card));
                    console.log(card.id + ".json created");
                }
            });
}

async function processingDecks() {
    // noinspection JSUnresolvedVariable
    for (let i = 0; i < json.length; i++) {
        try {
            const deck = await deckApi.retrieveDeck(json[i], expansion.lang);
            console.log(deck.data.name);
            // noinspection JSUnresolvedVariable
            extractCards(deck._linked.cards);
            await sleep(12000);
        } catch (error) {
            console.error('[' + i + '] Invalid status code ' + error);
            if (error === 429) break;
        }
    }
}

// noinspection JSUnresolvedVariable
console.log("Setup to processing " + json.length + " decks...");
processingDecks().then(() => console.log("Done!"));
