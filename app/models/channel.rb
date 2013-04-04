class Channel < ActiveRecord::Base
  acts_as_paranoid

  BEST_SLUGS = [ "devour", "theonion", "dudefood",
            "thrashermagazine", "jayz", "vice",
            "grantlandnetwork", "complexmagazine",
            "coolhunting", "iamother", "ap", "aljazeeraenglish",
            "theyoungturks", "lonelyplanet", "bbcearth", "networka",
            "epicmealtime", "ellen", "teamcoco", "funnyordie", "collegehumor", "mentalfloss",
            "bbc", "tedtalks", "asapscience", "minutephysics", "vsauce"]
  belongs_to :creator, :class_name => "User"

  # airings
  has_many :airings, :conditions => "airings.state != 'archived'", :order => "position ASC, airings.created_at DESC"
  has_many :videos, :through => :airings, :order => "airings.created_at DESC"
  has_many :archived_airings, :class_name => "Airing", :conditions => "airings.state = 'archived'", :order => "position ASC, airings.created_at DESC"
  has_many :archived_videos, :source => :video,  :through => :archived_airings

  #has_many :activities, class_name: "Activity", as: :secondary_subject, :order => "created_at DESC"
  has_many :activities, :through => :airings, :source => :attachments,
    class_name: "Activity", :order => "created_at DESC"

  has_many :likes, :through => :airings

  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, source: :user

  has_many :memberships,   :dependent => :destroy
  has_many :members, through: :memberships, source: :user

  has_many :channel_invites

  validates :title, uniqueness: true, presence: true
  validates :slug,  uniqueness: { :case_sensitive => false }, presence: true, :format => {:with => /^[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*$/}

  mount_uploader :cover_art, CoverArtUploader

  before_save :update_airings_count
  before_validation :downcase_slug

  scope :publik, where("private IS NULL").where("channels.airings_count > ?", 0)
  scope :explore, reorder("channels.airings_count DESC")
  scope :explore_for, lambda {|user| not_in = user.following_channels + user.channels; where("channels.id NOT IN (?)", not_in).explore}
  scope :omit_following, lambda {|user| not_in = user.following_channels + user.channels; where("channels.id NOT IN (?)", not_in)}


  def self.best
    best = Channel.where(:slug => BEST_SLUGS)
  end

  def downcase_slug
    self.slug = self.slug.downcase if self.slug.present?
  end

  def parties
    [creator] + members
  end

  def activities
    Activity.where("(subject_type = 'Airing' and subject_id IN (?)) or (subject_type = 'Channel' and subject_id = (?))", airings, self.id)
  end

  def description
    (self[:description].blank? and airings.any?) ? "i.e. #{airings.first.title}" : self[:description]
  end

  def last_three_videos
    videos.limit(3)
  end

  # grab likes from yesterday
  def todays_likes
    dayEnd = DateTime.now.beginning_of_day
    dayStart = dayEnd - 1.day

    likes.where("likes.created_at > ? and likes.created_at < ?", dayStart, dayEnd)
  end

  def likes_from_last(duration)
   time_end = DateTime.now
   time_start = time_end - duration

   likes.where("likes.created_at > ? and likes.created_at < ?", time_start, time_end)
  end

  def all_airings
    airings + archived_airings
  end

  def self.default
    find(1)
  rescue ActiveRecord::RecordNotFound
    first
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

  def member?(user)
    memberships.where(:user_id => user.id).any? || user.owns?(self)
  end

  def has_airings?
    airings.any?
  end

  def favorited?(user)
    ! subscriptions.find(:first, :conditions => [ "user_id = ?", user.id]).nil?
  end

  def subscribed_by(user)
    s = subscriptions.create(:user_id => user.id)
    s.update_unread_count!
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
    next_airing_for_user(user) || next_airing_for_id(cid) || airings.first
  end

  def next_airing_for_user(user)
    return if user.blank?

    if airings.unread_by(user).any?
      next_unseen_airing_for_user user
    elsif subscribed_by? user
      next_since_last_seen_for_user user
    end
  end

  def next_airing_for_id(current_id)
    return if current_id.blank?
    return if ! airings.exists?(current_id)

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

  def next_since_last_seen_for_user(user)
    subscription = self.subscription_for user
    if subscription
      next_airing_for_id subscription.last_played_id
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
      only: [:id, :title, :description, :cover_art, :slug]
    }.merge options
    super
  end

  def to_param
    slug
  end

  private

  def update_airings_count
    self.airings_count = airings.reload.count
  end
end
