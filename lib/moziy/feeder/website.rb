module Moziy
  # youtube and vimeo rss feeds
  class Feeder::Website < Feeder
    def initialize(args)
      @source = args[:source_url]
      super(args)
    end

    def perform_on_entry(entry)
      puts "---- Parsing #{entry.title}"

      doc = Nokogiri::HTML(open(entry.url.to_s))

      src = doc.search("iframe").attribute("src")

      feed_params = {
        :channel_slug => @channel.slug,
        :url => src.to_s,
        :content => entry.summary,
        :created_at => entry.published
      }

      Delayed::Job.enqueue AddVideoFromFeedJob.new([feed_params])
    end

    def source
      @source
    end
  end
end
