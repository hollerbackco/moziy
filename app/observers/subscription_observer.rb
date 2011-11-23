class SubscriptionObserver < ActiveRecord::Observer
  
  def after_create(subscription)
    ChannelNotifier.subscribed(subscription.channel, subscription.user).deliver
  end

end
