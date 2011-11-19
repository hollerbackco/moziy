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
  
  def gen_random_string
    if random_string.nil?
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      string = ""
      1.upto(10) { |i| string << chars[rand(chars.size-1)] }
      self.random_string = string
    end
    random_string
  end

end
