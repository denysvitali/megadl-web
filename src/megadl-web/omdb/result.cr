require "json"

class OpenMovieDB
  class Result
    JSON.mapping(
      title: {key: "Title", type: String},
      year: {key: "Year", type: String},
      genre: {key: "Genre", type: String},
      poster: {key: "Poster", type: String},
      country: {key: "Country", type: String},
      language: {key: "Language", type: String},
      type: {key: "Type", type: String},
      imdbRating: String
    )
  end
end
