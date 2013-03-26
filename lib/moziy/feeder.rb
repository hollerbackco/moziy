module Moziy
  class Feeder
    class AbstractError < StandardError; end

    def initialize(feed)
      @feed = feed
      user = feed.user

      @channel = feed.channel

      @last_updated = (@channel.airings.count > 0) ?
        @channel.airings.first.created_at :
        nil
    end

    def perform
      for entry in entries
        if !@last_updated or entry.published > @last_updated
          perform_on_entry entry
        else
          puts "no more posts for /#{@channel.slug}"
          break
        end
      end
    end

    def perform_on_entry(entry)
      raise AbstractError, "perform_on_entry must be defined"
    end

    def source
      raise AbstractError, "source must be defined"
    end

    def stream_details
      raise AbstractError, "stream_details must be defined"
    end

    private

    def entries
      feed = ::Feedzirra::Feed.fetch_and_parse(source)
      @entries ||= feed.is_a?(Fixnum) ? feed.entries : []

    end
  end
end
