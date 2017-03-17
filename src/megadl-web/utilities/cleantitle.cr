module Utilities
  class CleanTitle
    def self.clean(title : String)
      title = title.gsub(/\./," ")
      title = title.gsub(/((1080|720)(p|)|x26\d)/,"")
      titleMatches = / ([^\[\]]+)(?:\(|)(\d{4})(?:\)|)/.match(title)
      if titleMatches && titleMatches[1]
        title = titleMatches[1] + " (#{titleMatches[2]})"
      end
      title
    end
  end
end
