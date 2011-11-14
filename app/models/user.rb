class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  has_and_belongs_to_many :channels
  
  has_many :subscriptions
  has_many :channel_list, :through => :subscriptions, :foreign_key => :channel
  
  def owns?(obj)
    self.id == obj.creator_id
  end
  
end
