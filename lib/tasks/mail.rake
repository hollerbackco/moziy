namespace :mail do
  desc "send like emails"
  task :likes => :environment do
    Channel.all.each do |channel|
      likes = channel.likes_from_last 1.day
      send_likes likes, channel
    end
  end

  desc "send added to members"
  task :added => :environment do
    airings = Airing.since(Time.now - 10.minutes).order("created_at ASC")
    channel_with_airings = airings.group_by {|airing| airing.channel_id}

    p "new airings", channel_with_airings
    channel_with_airings.each do |channel_id, airings|
      channel = Channel.find(channel_id)
      p channel, channel.parties.count
      if channel.parties.count > 1
        channel.parties.each do |user|
          relevant_airings = airings.keep_if {|a| a.user_id != user.id}

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

  def send_likes(likes,channel)
    if likes.any?
      ChannelMailer.liked(channel, likes).deliver
      p likes
    end
  end
end
