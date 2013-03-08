module Moziy
  # youtube and vimeo rss feeds
  class Feeder::Vimeo < Feeder::Standard
    def source
      @source || "http://vimeo.com/#{@source_username}/videos/rss"
    end
  end
end
