module Moziy
  class Feeder
    class AbstractError < StandardError; end

    def initialize(args)
      user = Channel.default.creator

      @channel = user.channels.where(slug: args[:slug]).first_or_create do |channel|
        channel.slug = args[:slug]
        channel.title = args[:title]
        channel.description = args[:description]
      end

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
      @entries ||= feed.present? ? feed.entries : []
    end
  end
end
