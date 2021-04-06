const fs = require("fs");
const request = require("request");

const retrieveImage = function(url, path) {
  return new Promise((resolve, reject) => {
    request.head(url, error => {
      if (error) reject(error);
      request(url)
        .pipe(fs.createWriteStream(path))
        .on("close", () => resolve(path));
    });
  });
};

exports.retrieveImage = retrieveImage;
