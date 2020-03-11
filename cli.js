const program = require('commander');
const chalk = require('chalk');

const packageJson = require('./package.json');

const version = packageJson.version;

const importDeck = function(deck, options) {
    console.info(chalk.blue(`Import deck: ${deck} with ${options.cockatrice ? 'cocatrice' : 'standard'} output`));
};

program
        .version(version)
        .usage('[command] [options]')
        .allowUnknownOption();

program
        .command('import <deck>')
        .description('Import deck')
        .option('-c, --cockatrice', 'Cockatrice output')
        .action(importDeck);

program.parse(process.argv);

if (!process.argv.slice(2).length) {
    program.outputHelp();
}
