class Video < ActiveRecord::Base
  
  has_many :airings, :dependent => :destroy
  
  validates :title, :presence => true
  validates :body, :presence => true
  
end
