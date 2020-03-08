const fs = require("fs");

const configs = require('./config');
const messages = require('./messages');

const houses = messages[configs.lang].houses;

configs.expansion.forEach(expansion => {
    console.log("Loading cards from " + expansion.longname + "...");
    const cardsFolder = './json/' + expansion.lang + '/' + expansion.name + '/';
    const setFile = './xml/' + expansion.lang + '/' + expansion.name + '.xml';
    const cards = fs.readdirSync(cardsFolder);
    fs.writeFileSync(setFile, '<?xml version="1.0" encoding="UTF-8"?>\n<cockatrice_carddatabase version="4">\n    <sets>\n        <set>\n            <name>' + expansion.name + '</name>\n            <longname>' + expansion.longname + '</longname>\n            <settype>Custom</settype>\n            <releasedate>' + expansion.release + '</releasedate>\n        </set>\n    </sets>\n    <cards>\n', {flag: 'w'});
    console.log("Setup to processing " + cards.length + " cards...");
    cards.forEach(file => {
        let card = JSON.parse(fs.readFileSync(cardsFolder + file));
        fs.writeFileSync(setFile, '        <card>\n', {flag: 'a'});
        fs.writeFileSync(setFile, '            <name>' + card.card_title + '</name>\n', {flag: 'a'});
        fs.writeFileSync(setFile, '            <text>' + card.card_text.replace(/_x000D_/gi, '\n') + '</text>\n', {flag: 'a'});
        if (card.card_type === 'Creature' || card.card_type === 'Artifact') fs.writeFileSync(setFile, '            <cipt>1</cipt>\n', {flag: 'a'});
        let row = 2;
        if (card.card_type === 'Artifact') row = 0;
        if (card.card_type === 'Upgrade') row = 1;
        if (card.card_type === 'Action') row = 3;
        fs.writeFileSync(setFile, '            <tablerow>' + row + '</tablerow>\n', {flag: 'a'});
        fs.writeFileSync(setFile, '            <set rarity="' + card.rarity + '" uuid="' + card.id + '" num="' + card.card_number + '" muid="' + expansion.code + '-' + card.card_number + '" picurl="' + card.front_image + '">' + expansion.name + '</set>\n', {flag: 'a'});
        fs.writeFileSync(setFile, '            <prop>\n', {flag: 'a'});
        fs.writeFileSync(setFile, '                <layout>normal</layout>\n                <side>front</side>\n', {flag: 'a'});
        fs.writeFileSync(setFile, '                <type>' + (card.traits ? card.traits : card.card_type) + '</type>\n                <maintype>' + card.card_type + '</maintype>\n', {flag: 'a'});
        if (!card.is_anomaly) fs.writeFileSync(setFile, '                <colors>' + houses[card.house].name + '</colors>\n                <coloridentity>' + houses[card.house].name + '</coloridentity>\n', {flag: 'a'});
        if (card.card_type === 'Creature') fs.writeFileSync(setFile, '                <pt>' + card.power + '/' + (card.armor ? card.armor : 0) + '</pt>\n', {flag: 'a'});
        if (card.amber > 0) fs.writeFileSync(setFile, '                <loyalty>' + card.amber + '</loyalty>\n', {flag: 'a'});
        fs.writeFileSync(setFile, '                <format-standard>ilegal</format-standard>\n                <format-commander>ilegal</format-commander>\n                <format-modern>ilegal</format-modern>\n                <format-pauper>ilegal</format-pauper>\n', {flag: 'a'});
        fs.writeFileSync(setFile, '            </prop>\n', {flag: 'a'});
        fs.writeFileSync(setFile, '        </card>\n', {flag: 'a'});
    });
    fs.writeFileSync(setFile, '    </cards>\n</cockatrice_carddatabase>', {flag: 'a'});
});
