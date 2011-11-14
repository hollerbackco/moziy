class Subscription < ActiveRecord::Base
  belongs_to :channel, :counter_cache => true
  belongs_to :user
end
