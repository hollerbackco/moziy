class Channel < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  has_many :airings, :conditions => "airings.state != 'archived'", :order => "position ASC, video_id DESC", :dependent => :destroy
  has_many :videos, :through => :airings

  has_many :archived_airings, :class_name => "Airing", :conditions => "airings.state = 'archived'", :order => "position ASC, video_id DESC", :dependent => :destroy
  has_many :archived_videos, :source => :video,  :through => :archived_airings

  has_many :subscriptions, :dependent => :destroy

  validates :title, uniqueness: true, presence: true
  validates :slug,  uniqueness: true, presence: true, :format => {:with => /^([a-zA-Z](_?[a-zA-Z0-9]+)*_?|_([a-zA-Z0-9]+_?)*)$/}

  mount_uploader :cover_art, CoverArtUploader

  scope :publik, where("private IS NULL")

  def self.default
    find(11)
  rescue ActiveRecord::RecordNotFound
    if Channel.count > 0
      Channel.find(2)
    else
      Channel.create(title: "MoseyTv")
    end
  end

  def subscription_for(user)
    subscriptions.find_by_user_id(user.id)
  end

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
    subscriptions.create(:user_id => user.id)
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


  def needs_crawl?
    false
  end

  # gets the next video in the order.  accepts an id.
  def next_video(current_id)
    @video_ids = airings.map {|a| a.video_id }

    @current_index = @video_ids.index current_id.to_i

    if @current_index
      next_index = (@current_index + 1) % self.videos.count
      Video.find(@video_ids[next_index])
    else
    # give the next video or the first if current_index not set.
      Video.find(@video_ids[rand(self.videos.count)])
    end
  end

  def next_airing(cid=nil,user=nil)
    if user and airings.unread_by(user).count > 0
      next_unseen_airing_for_user user
    elsif cid and airings.exists? cid
      next_airing_for_id cid
    else
      airings.first
    end
  end

  def next_airing_for_id(current_id)
    ids = airings.map {|a| a.id }

    current_index = ids.index current_id.to_i

    if current_index
      next_index = (current_index + 1) % self.airings.count
      airings.find(ids[next_index])
    else
      # give the next video or the first if current_index not set.
      airings.first
    end
  end

  def next_unseen_airing_for_user(user)
    airings.unread_by(user).first
  end

  def find_airing_from_video_id(id)
    airings.find(:first, conditions: {video_id: id})
  end

  def channel_subscribers_count
    subscriptions.count
  end

  def as_json(options={})
    options = {
      methods: [:channel_subscribers_count],
      only: [:id, :title, :description, :cover_art, :slug],
      include: [:creator]
    }.merge options
    super
  end
end
