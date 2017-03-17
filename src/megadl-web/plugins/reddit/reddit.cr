require "cossack"
require "xml"
require "../plugins.cr"
require "../../utilities/cleantitle.cr"


class Reddit
  extend Plugins
  @@endpoint = "http://reddit.com"
  @@subreddit = "megalinks"
  @@Movies = [] of Tuple(String, String)
  @@cossack = Cossack::Client.new do |client|
    client.use Cossack::RedirectionMiddleware, limit: 10
    client.headers["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0"
  end

  def fetch
    # document = File.read("web.html")
    baseUrl = "#{@@endpoint}/r/#{@@subreddit}.json"
    response = @@cossack.get baseUrl
    document = response.body
    json = JSON.parse(document)
    output = {} of String => String
    if json["data"]
      json["data"]["children"].each do |el|
        if el["kind"] == "t3"
          if el["data"]["title"].to_s.match /\[(?:movie|music)\]/i
            matches = el["data"]["selftext"].to_s.match /#(?:F|)\![A-z0-9]{6,}/
            keyMatch = el["data"]["selftext"].to_s.match /\![A-z0-9_-]{22,}/

            if matches
              cleanTitle =  Utilities::CleanTitle.clean el["data"]["title"].to_s

              if keyMatch
                output[cleanTitle] = "http://mega.nz/#{matches[0]}#{keyMatch[0]}"
              else
                key = getKey el["data"]["permalink"].to_s + ".json"
                output[cleanTitle] = "http://mega.nz/#{matches[0]}#{key}"
              end
            end
          end
        end
      end
    end
    output
  end

  def getKey(url : String)
    response = @@cossack.get "http://reddit.com" + url
    document = response.body
    json = JSON.parse(document)

    json[1]["data"]["children"].each do |el|
      match = /(\![A-z0-9_-]{22,})/.match(el["data"]["body"].to_s)
      if match
        return match[1]
      end
    end
    ""
  end

  def fetchMovie(url : String)
    response = @@cossack.get url
    document = response.body
    #puts document
    megaLinks = [] of String
    matches = document.scan(/http(?:s|):\/\/(?:www\.|)(?:mega\.(?:co\.|)nz|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/#[^"]*/mi) do |res|
        megaLinks << res[0].to_s
    end
    megaLinks.uniq!

  end
end
