class User < ActiveRecord::Base
  class UserFeed
    attr_accessor :user, :unwatched, :all, :offset_id

    def initialize(user, options = {})
      self.user = user
      self.unwatched = user.unwatched_feed
      self.all = user.all_feed
    end

    def get(options = {})
      self.offset_id = options[:offset_id]
      read( first_unwatched || get_next_from_offset || all.first )
    end

    private

    def first_unwatched
      unwatched.any? ? unwatched.first : nil
    end

    def get_next_from_offset
      begin
        airing = Airing.find(offset_id)
        all_feed.next(airing)
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

    def read(airing)
      airing.mark_as_read! for: user

      subscription = airing.channel.subscription_for user
      subscription.decrement_unread_count!

      airing
    end
  end
end
