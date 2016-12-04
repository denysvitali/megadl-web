  // Scraper for cyro.se
  (() => {
      class Cyro {
          constructor() {
              this.request = require('request');
              console.log('Loaded');
          }

          fetchMovies(numPages = 1) {
              console.log('Fetching movies');
              return new Promise((res, rej) => {
                  this.request('http://cyro.se/movies/', (err, res, body) => {
                      if (err) {
                          rej(err);
                      }
                      let regex = new RegExp('<a href="(goto.*?)" target="_self"><p align="center"><font color="#000000">(.*?)<\/font><\/p><\/a>', 'ig');
                      let matches = body.match(regex);
                      let movies = [];
                      for (let i in matches) {
                          let match = matches[i].match(regex.source, 'i');
                          if ((!match) == false) {
                              movies.push({
                                  title: match[2],
                                  postUrl: 'http://cyro.se/movies/' + match[1]
                              });
                          }
                      }
                      console.log(movies);

                      let promArr = [];

                      let addMovie = (movie) => {
                          promArr.push(new Promise((resolve, rej) => {
                              this.request(movie.postUrl, (err, res, body) => {
                                  //console.log(res.statusCode);
                                  let match = body.match(/<a rel="nofollow" href="(.*?)" id="dm1" target="_blank">/i);
                                  movie.megaUrl = match[1];
                                  resolve(movie);
                              });
                          }));
                      };

                      for (let i in movies) {
                          addMovie(movies[i], promArr);
                      }

                      Promise.all(promArr).then((movies) => {

                          let cmd = '';
                          let downloadDir = '/home/plex/downloads_tmp/automega/';

                          for (let i in movies) {
                              console.log(movies[i].title);
                              console.log(movies[i].megaUrl);
                              console.log();

                              let sanDir = movies[i].title;
                              sanDir = sanDir.replace(/\//g, ' ');
                              sanDir = sanDir.replace(/\\/g, ' ');
                              sanDir = sanDir.replace(/[^0-9A-z()]/g, ' ');
                              let megalink = movies[i].megaUrl;

                              cmd += 'cd \'' + downloadDir + '\' && mkdir \'' + downloadDir + '/' + sanDir + '\'; cd \'' + downloadDir + '/' + sanDir + '\' && megadl \'' + megalink + '\'; '
                          }
                          console.log(cmd);
                      }).catch((err) => {
                          console.log(err);
                      });
                  });
              });
          }
      }

      module.exports = Cyro;
  })();
