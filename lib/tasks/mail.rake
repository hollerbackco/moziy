namespace :mail do
  desc "send like emails"
  task :likes => :environment do
    Channel.all.each do |channel|
      likes = channel.likes_from_last 1.hour
      send_likes likes, channel
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
