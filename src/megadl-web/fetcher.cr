require "./plugins/cyrose/cyrose.cr"
require "./plugins/reddit/reddit.cr"
require "./omdb/result.cr"
module Megadl::Web
  class Fetcher
    def initialize()

    end

    def fetch
      reddit = Reddit.new
      redditRes = reddit.fetch

      movies = [] of Tuple(String, String)
      moviesResult = [] of Tuple(String, String, (OpenMovieDB::Result|Nil))
      if redditRes
        redditRes.each do |el|
          movies << el
        end
      end

      cyrose = Cyrose.new
      cyroseRes = cyrose.fetch

      if cyroseRes
        cyroseRes.each do |el|
          movies << el
        end
      end

      movies.each do |el|
        moviesResult << {el[0], el[1], omdb_get(el[0])}
      end

      moviesResult
    end

    def omdb_get(title : String = "")
      matches = /^(.*?) \((\d{4})\)/.match(title)

      if matches
        escaped_title = URI.escape matches[1]
        year = matches[2]
        uri = URI.parse("http://www.omdbapi.com/?t=#{escaped_title}&y=#{year}")
        puts uri
        client = HTTP::Client.get uri
        OpenMovieDB::Result.from_json client.body
      else
        nil
      end
    end
  end
end
