namespace :mail do
  desc "send like emails"
  task :likes => :environment do
    Channel.all.each do |channel|
      likes = channel.likes_from_last 1.hour
      if likes.any?
        ChannelMailer.liked(channel, likes).deliver
        p likes
      end
    end
  end
end
