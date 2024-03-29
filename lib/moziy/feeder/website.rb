module Moziy
  # youtube and vimeo rss feeds
  class Feeder::Website < Feeder
    def initialize(feed)
      super(feed)
      @source = feed.source_url
    end

    def perform_on_entry(entry)
      puts "---- Parsing #{entry.title}"

      doc = Nokogiri::HTML(open(entry.url.to_s))

      iframe = doc.search("iframe")

      if iframe
        src = iframe.attribute("src")
        puts src.to_s

        feed_params = {
          :channel_slug => @channel.slug,
          :url => src.to_s,
          :content => entry.summary,
          :created_at => entry.published
        }

        Delayed::Job.enqueue AddVideoFromFeedJob.new([feed_params])
      end
    end

    def source
      @source
    end
  end
end
