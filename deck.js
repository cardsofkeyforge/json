const request = require("request");

const retrieveDeck = function(deck, lang, links) {
  const options = {
    method: "GET",
    url:
      "https://www.keyforgegame.com/api/decks/" +
      deck +
      (links ? "?links=cards" : ""),
    headers: {
      "Accept-Language": lang
    }
  };

  return new Promise((resolve, reject) => {
    request(options, function(error, response, body) {
      if (error) throw new Error(error);
      if (response.statusCode === 200) {
        resolve(JSON.parse(body));
      } else {
        reject(response.statusCode);
      }
    });
  });
};

const retrieveDecks = function(expansion, lang, page) {
  const options = {
    method: "GET",
    url: `https://www.keyforgegame.com/api/decks?page=${page}&page_size=25&ordering=date&expansion=${expansion}`,
    headers: {
      "Accept-Language": lang
    }
  };

  return new Promise((resolve, reject) => {
    request(options, function(error, response, body) {
      if (error) throw new Error(error);
      if (response.statusCode === 200) {
        resolve(JSON.parse(body));
      } else {
        reject(response.statusCode);
      }
    });
  });
};

exports.retrieveDeck = retrieveDeck;
exports.retrieveDecks = retrieveDecks;
