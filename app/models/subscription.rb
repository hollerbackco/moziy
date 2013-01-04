class Subscription < ActiveRecord::Base
  belongs_to :channel, :counter_cache => true
  belongs_to :user

  validates :channel_id, :uniqueness => {:scope => [:user_id]}

  def update_unread_count!
    update_attribute(:unread_count, channel.airings.unread_by(user).count)
  end
end
