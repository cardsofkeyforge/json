const fs = require('fs');
const ejs = require('ejs');

const configs = require('./config');
const messages = require('./messages');

const houses = messages[configs.lang].houses;

configs.expansion.forEach(expansion => {
    console.log('Loading cards from ' + expansion.longname + '...');
    const cardsFolder = './json/' + expansion.lang + '/' + expansion.name + '/';
    const setFile = './xml/' + expansion.lang + '/' + expansion.name + '.xml';
    const cards = fs.readdirSync(cardsFolder);
    console.log('Setup to processing ' + cards.length + ' cards...');
    ejs.renderFile('./xml/set.ejs', {
        expansion: expansion,
        cards: cards.map(card => JSON.parse(fs.readFileSync(cardsFolder + card))),
        houses: houses
    }, {filename: setFile}, function(err, str) {
        if (!err) fs.writeFileSync(setFile, str, {flag: 'w'});
    });
});
