# KeyForge Cards Extractor Tool

A very simple tool made in `javascript` to batch creation of json files for **KeyForge** cards.

## Configure

1.  Edit the `config.json` file and enter a valid expansion data.
2.  Edit the `decks.json` file by adding deck ids's to array. For example:

```json
[
  "00000000-0000-0000-0000-000000000000",
  "00000000-0000-0000-0000-000000000001",
  "00000000-0000-0000-0000-000000000002",
  "00000000-0000-0000-0000-000000000003"
]
```

## Usage

So far there are 8 distinct commands. See more below.

### Creating the Jsons

To create the JSON files for all the cards present on the decks informed, run the following command:

```bash
$ npm run createJsons
```

### Creating the Xmls for Cockatrice

To create the XML files for all the sets with the Jsons already created, run the following command:

```bash
$ npm run createXmls
```

### Importing Decks for Cockatrice

To create the COD files for all the decks informed, run the following command:

```bash
$ npm run importDecks
```

### Generating GitHub Pages for Cards

To generate the GitHub Pages for all the sets with the Jsons already created, run the following command:

```bash
$ npm run generatePages
```

### Generating Card Images

To generate the images of all cards for all the sets with the Jsons already created, run the following command:

```bash
$ npm run generateImages
```

### Generating Cards Statistics

To generate the card totals by sets and general, run the following command:

```bash
$ npm run generateStats
```

### Generating Collection Statistics

To generate the card totals by sets and general of a collection, run the following command:

```bash
$ npm run generateCollectionStats
```

> Place the collection in the "collection" folder one file per set (`cota.json`, `aoa.json`, etc.).

### Importing Decks for TTS (KF)

To create the TTS file for a KeyForge deck, run the following command:

```bash
$ npm run vaultToTTS <DECK ID>
```

### Importing Decks for TTS (MTG)

To create the TTS file for a Magic deck, run the following command:

```bash
$ npm run scryfallToTTS <Scryfall Deck File.json> <Sleeve Color>
```

The available sleeves colors are:
- Red
- Blue
- Black
