require "cossack"
require "xml"
require "../plugins.cr"


class Cyrose
  extend Plugins
  @@endpoint = "http://cyro.se"
  @@Movies = {} of String => String
  @@cossack = Cossack::Client.new do |client|
    # follow up to 10 redirections (by default 5)
    client.use Cossack::RedirectionMiddleware, limit: 10
    client.headers["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0"
  end

  def fetch
    # document = File.read("web.html")
    baseUrl = "#{@@endpoint}/movies/"
    response = @@cossack.get baseUrl
    document = response.body
    matches = document.scan(/<table[^>]*? class="topic_table".*?>*?<td[^>]*?class="topic_head"[^>]*?>.*?<a href="(goto-.*?)".*?>.*?<font[^>]*?>(.*?)<\/font>.*?<\/td>/m) do |res|
      if res && res[0]
        @@Movies[res[2]] = self.fetchMovie("#{baseUrl}#{res[1]}")[0]#, res[2])
      end
    end
    @@Movies
  end

  def fetchMovie(url : String)
    response = @@cossack.get url
    document = response.body
    #puts document
    megaLinks = [] of String
    matches = document.scan(/http(?:s|):\/\/(?:www\.|)mega\.(?:co\.|)nz\/#[^"]*/mi) do |res|
        megaLinks << res[0].to_s
    end
    megaLinks.uniq!

  end
end
