class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  has_and_belongs_to_many :channels
  
  def owns?(obj)
    self.id == obj.creator_id
  end
  
end
