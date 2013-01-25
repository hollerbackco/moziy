namespace :mail do
  desc "send like emails"
  task :likes => :environment do
    Channel.all.each do |channel|
      if channel.todays_likes.count > 0
        ChannelMailer.liked(channel).deliver
      end
    end
  end
end
