namespace :mail do
  desc "send like emails"
  task :likes => :environment do
    likes = Like.since(Time.now - 1.hour).order("created_at ASC")
    channel_with_likes = likes.group_by {|like| like.likeable.channel_id}

    channel_with_likes.each do |channel_id, likes|
      channel = Channel.find channel_id

      channel.parties.each do |user|
        relevant = likes.select {|like| like.user_id != user.id}

        if relevant.any?
          ChannelMailer.liked(user, channel, relevant).deliver
          p user, channel, relevant
        end
      end

    end
  end

  desc "send added to members"
  task :added => :environment do
    airings = Airing.since(Time.now - 10.minutes).order("created_at ASC")
    channel_with_airings = airings.group_by {|airing| airing.channel_id}

    channel_with_airings.each do |channel_id, airings|
      channel = Channel.find(channel_id)
      if channel.parties.count > 1
        channel.parties.each do |user|
          relevant_airings = airings.select {|a| a.user_id != user.id}

          if relevant_airings.any?
            ChannelMailer.added(user, channel, relevant_airings).deliver
            p user, channel, relevant_airings
          end
        end
      end
    end
  end

  desc "send likes from last day"
  task :likes_day => :environment do
    Channel.all.each do |channel|
      likes = channel.likes_from_last 1.day
      send_likes likes, channel
    end
  end

end
