class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  has_many :channels, :foreign_key => "creator_id"
  
  has_many :subscriptions
  has_many :channel_list, :through => :subscriptions, :source => :channel
  
  def owns?(obj)
    self.id == obj.creator_id
  end
  
end
