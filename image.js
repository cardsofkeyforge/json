const fs = require("fs");
const request = require("request");

const retrieveImage = function(url, path) {
  return new Promise((resolve, reject) => {
    request.head(url, (error, response) => {
      if (error) reject(error);
      request(url)
        .pipe(fs.createWriteStream(path))
        .on("close", () =>
          resolve(response.statusCode === 200 ? path : "[ERROR]")
        );
    });
  });
};

exports.retrieveImage = retrieveImage;
