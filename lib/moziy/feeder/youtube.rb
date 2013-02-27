module Moziy
  # youtube and vimeo rss feeds
  class Feeder::Youtube < Feeder::Standard
    def source
      "http://gdata.youtube.com/feeds/base/users/#{@source_username}/uploads?alt=rss&v=2&orderby=published&client=ytapi-youtube-profile"
    end
  end
end
