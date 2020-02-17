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

To create the json files for all the cards present on the decks informed, run the following command:

```bash
$ npm run createJsons
```
