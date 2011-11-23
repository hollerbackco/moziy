class Subscription < ActiveRecord::Base
  belongs_to :channel, :counter_cache => true
  belongs_to :user
  
  validates :channel_id, :uniqueness => {:scope => [:user_id]}
  
end
