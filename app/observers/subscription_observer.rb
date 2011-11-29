class SubscriptionObserver < ActiveRecord::Observer
  
  def after_create(subscription)
    if subscription.channel.creator !=  subscription.user
      ChannelMailer.subscribed(subscription.channel, subscription.user).deliver
    end
  end

end
