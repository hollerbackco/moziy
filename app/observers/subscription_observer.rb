class SubscriptionObserver < ActiveRecord::Observer
  
  def after_create(subscription)
    ChannelMailer.subscribed(subscription.channel, subscription.user).deliver
  end

end
