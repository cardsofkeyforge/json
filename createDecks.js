const fs = require("fs");

const configs = require('./config');
const json = require("./decks");
const deckApi = require("./deck");

function sleep(millis) {
    return new Promise(resolve => setTimeout(resolve, millis));
}

function extractCards(id, name, cards, expansion) {
    const jsons = './json/' + expansion.lang + '/' + expansion.name + '/';
    const deck = './decks/' + expansion.lang + '/' + expansion.name + '/' + name + '.cod';
    console.log("Creating " + deck + "...");
    fs.writeFileSync(deck, '<?xml version="1.0" encoding="UTF-8"?>\n<cockatrice_deck version="1">\n    <deckname>' + name + '</deckname>\n    <comments>' + id + '</comments>\n    <zone name="main">\n', {flag: 'w'});
    let n = 0;
    let c = "";
    cards.forEach(cardId => {
        const card = JSON.parse(fs.readFileSync(jsons + cardId + '.json'));
        if (c !== card.card_title && n > 0) {
            fs.writeFileSync(deck, '        <card number="' + n + '" name="' + c + '"/>\n', {flag: 'a'});
            n = 0;
        }
        c = card.card_title;
        n++;
    });
    fs.writeFileSync(deck, '        <card number="' + n + '" name="' + c + '"/>\n', {flag: 'a'});
    fs.writeFileSync(deck, '    </zone>\n</cockatrice_deck>', {flag: 'a'});
}

async function processingDecks() {
    // noinspection JSUnresolvedVariable
    for (let i = 0; i < json.length; i++) {
        try {
            const deck = await deckApi.retrieveDeck(json[i], configs.lang, false);
            console.log(deck.data.name);
            // noinspection JSUnresolvedVariable
            extractCards(deck.data.id, deck.data.name, deck.data.cards, configs.expansion.find(e => e.code === deck.data.expansion));
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
