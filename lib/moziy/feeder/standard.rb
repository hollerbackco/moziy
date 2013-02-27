module Moziy
  # youtube and vimeo rss feeds
  class Feeder::Standard < Feeder

    def initialize(args)
      @source_username = args[:source_name]
      super(args)
    end

    def perform_on_entry(entry)
      puts "---- Parsing #{entry.title}"

      feed_params = {
        :channel_slug => @channel.slug,
        :url => entry.url.to_s,
        :content => entry.summary,
        :created_at => entry.published
      }

      Delayed::Job.enqueue AddVideoFromFeedJob.new([feed_params])
    end
  end
end
