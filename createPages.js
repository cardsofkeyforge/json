const fs = require("fs");
const ejs = require("ejs");

const configs = require('./config');
const messages = require('./messages');

const houses = messages[configs.lang].houses;
const types = messages[configs.lang].types;
const rarities = messages[configs.lang].rarities;

function createPage(card, expansion) {
    const cardPage = './pages/' + expansion.lang + '/' + expansion.name + '/' + card.card_number + '.md';

    ejs.renderFile('./pages/' + expansion.lang + '/page.ejs', {
        expansion: expansion,
        card: card,
        house: card.is_anomaly ? null : houses[card.house],
        type: types[card.card_type],
        text: card.card_text ? card.card_text.replace(/_x000D_/g, ' ').replace(/\n/g, ' ').replace(/\r/g, ' ') : null,
        rarity: rarities[card.rarity],
        flavor: card.flavor_text ? card.flavor_text.replace(/_x000D_/g, ' ').replace(/\n/g, ' ').replace(/\r/g, ' ') : null
    }, {filename: cardPage}, function(err, str) {
        if (!err) fs.writeFileSync(cardPage, str, {flag: 'w'});
    });
}

configs.expansion.forEach(expansion => {
    console.log("Loading cards from " + expansion.longname + "...");
    const cardsFolder = './json/' + expansion.lang + '/' + expansion.name + '/';
    const cards = fs.readdirSync(cardsFolder);
    console.log("Setup to processing " + cards.length + " cards...");
    const set = [];
    cards.forEach(file => {
        let card = JSON.parse(fs.readFileSync(cardsFolder + file));
        set.push(card);
    });
    set.sort((c1, c2) => String(c1.card_number).localeCompare(c2.card_number))
            .forEach(card => createPage(card, expansion));
});