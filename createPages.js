const fs = require("fs");

const configs = require('./config');

const houses = {
    'Brobnar': {name: 'Brobnar', image: 'https://archonarcana.com/images/thumb/e/e0/Brobnar.png/22px-Brobnar.png'},
    'Dis': {name: 'Dis', image: 'https://archonarcana.com/images/thumb/e/e8/Dis.png/22px-Dis.png'},
    'Logos': {name: 'Logos', image: 'https://archonarcana.com/images/thumb/c/ce/Logos.png/22px-Logos.png'},
    'Mars': {name: 'Marte', image: 'https://archonarcana.com/images/thumb/d/de/Mars.png/22px-Mars.png'},
    'Sanctum': {name: 'Santuário', image: 'https://archonarcana.com/images/thumb/c/c7/Sanctum.png/22px-Sanctum.png'},
    'Saurian': {name: 'Sauro', image: 'https://archonarcana.com/images/thumb/9/9e/Saurian_P.png/22px-Saurian_P.png'},
    'Shadows': {name: 'Sombras', image: 'https://archonarcana.com/images/thumb/e/ee/Shadows.png/22px-Shadows.png'},
    'Star Alliance': {
        name: 'Aliança Estelar',
        image: 'https://archonarcana.com/images/thumb/7/7d/Star_Alliance.png/22px-Star_Alliance.png'
    },
    'Untamed': {name: 'Indomados', image: 'https://archonarcana.com/images/thumb/b/bd/Untamed.png/22px-Untamed.png'}
};

const types = {
    'Creature': 'Criatura',
    'Action': 'Ação',
    'Upgrade': 'Melhoria',
    'Artifact': 'Artefato'
};

const rarities = {
    'Common': 'Comum',
    'Uncommon': 'Incomum',
    'Rare': 'Rara',
    'FIXED': 'Especial'
};

function createPage(card, expansion) {
    const cardPage = './pages/' + expansion.lang + '/' + expansion.name + '/' + card.card_number + '.md';
    fs.writeFileSync(cardPage, '---\ntitle: ' + expansion.longname + '\nsubtitle: ' + expansion.releaseDate + '\nlayout: page\nshow_sidebar: false\nhero_image: ' + expansion.image + '\n---\n\n', {flag: 'w'});
    fs.writeFileSync(cardPage, '![' + card.card_number + '](' + card.front_image + ')\n\n', {flag: 'a'});
    fs.writeFileSync(cardPage, '## ' + card.card_title + '\n\n', {flag: 'a'});
    fs.writeFileSync(cardPage, '|----|----|\n', {flag: 'a'});
    fs.writeFileSync(cardPage, '| ID | ' + card.id + ' |\n', {flag: 'a'});
    fs.writeFileSync(cardPage, '| Número | ' + card.card_number + ' |\n', {flag: 'a'});
    if (!card.is_anomaly) fs.writeFileSync(cardPage, '| Casa | ![' + card.house + '](' + houses[card.house].image + ' "' + houses[card.house].name + '") |\n', {flag: 'a'});
    fs.writeFileSync(cardPage, '| Tipo | ' + types[card.card_type] + ' |\n', {flag: 'a'});
    if (card.traits) fs.writeFileSync(cardPage, '| Atributos | ' + card.traits + ' |\n', {flag: 'a'});
    if (card.amber) fs.writeFileSync(cardPage, '| Bônus | ' + card.amber + 'A |\n', {flag: 'a'});
    if (card.card_type === 'Creature') fs.writeFileSync(cardPage, '| Poder | ' + card.power + ' |\n', {flag: 'a'});
    if (card.card_type === 'Creature') fs.writeFileSync(cardPage, '| Armadura | ' + (card.armor ? card.armor : '0') + ' |\n', {flag: 'a'});
    if (card.card_text) fs.writeFileSync(cardPage, '| Texto | ' + card.card_text.replace(/_x000D_/, ' ').replace(/\n/, ' ').replace(/\r/, ' ') + ' |\n', {flag: 'a'});
    fs.writeFileSync(cardPage, '| Raridade | ' + rarities[card.rarity] + ' |\n', {flag: 'a'});
    if (card.flavor_text) fs.writeFileSync(cardPage, '| Dizeres | ' + card.flavor_text.replace(/_x000D_/, ' ').replace(/\n/, ' ').replace(/\r/, ' ') + ' |', {flag: 'a'});
    if (card.errata) fs.writeFileSync(cardPage, '\n### Errata\n\n' + card.errata, {flag: 'a'})
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
    set.sort((c1, c2) => new String(c1.card_number).localeCompare(c2.card_number))
            .forEach(card => createPage(card, expansion));
});
