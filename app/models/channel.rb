class Channel < ActiveRecord::Base
  
  belongs_to :owner, :class_name => "User"
  has_many :airings
  has_many :videos, :through => :airings
  
  
  validates :title, :uniqueness => true, :presence => true
end
