class Video < ActiveRecord::Base

  has_many :airings, :dependent => :destroy
  has_many :likes, through: :airings

  validates :title, :presence => true
  validates :body, :presence => true
  validates :source_name, :presence => true, :uniqueness => {:scope => [:source_id]}
  validates :source_id, :presence => true

end
