class Channel < ActiveRecord::Base
  
  belongs_to :creator, :class_name => "User"
  has_many :airings, :order => "position ASC, video_id DESC", :dependent => :destroy
  has_many :videos, :through => :airings
  
  has_many :subscriptions
  
  validates :title, :uniqueness => true, :presence => true
  
  mount_uploader :cover_art, CoverArtUploader
  
  def subscribed_by?(user)
    ! Subscription.find_by_user_id_and_channel_id(user.id, self.id).nil?
  end
  
  def now_playing
    airings.first.video
  end
  
  def has_airings?
    airings.count > 0
  end
  
  def favorited?(user)
    ! subscriptions.find(:first, :conditions => [ "user_id = ?", user.id]).nil?
  end
  
  def subscribed_by(user)
    Subscription.create()
  end
  

end
