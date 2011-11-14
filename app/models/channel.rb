class Channel < ActiveRecord::Base
  
  belongs_to :creator, :class_name => "User"
  has_many :airings, :order => "position ASC, video_id DESC", :dependent => :destroy
  has_many :videos, :through => :airings
  
  validates :title, :uniqueness => true, :presence => true
  
end
