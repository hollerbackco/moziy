class User < ActiveRecord::Base
  attr_accessible :email, :username, :password, :password_confirmation,
    :primary_channel, :primary_channel_id, :preferences

  acts_as_reader
  authenticates_with_sorcery!

  # associations
  belongs_to :primary_channel, class_name: "Channel"

  has_many :channels, :foreign_key => "creator_id", :order => "created_at ASC", :dependent => :destroy
  has_many :airings, through: :channels

  has_many :memberships
  has_many :collab_channels, through: :memberships, class_name: "Channel", source: :channel

  has_many :subscriptions, order: "last_added_airing_at DESC", :dependent => :destroy
  has_many :following_channels, through: :subscriptions, class_name: "Channel", source: :channel,
    order: "subscriptions.last_added_airing_at DESC",
    select: "channels.*, subscriptions.unread_count"

  has_many :likes, order: "likes.created_at DESC"
  has_many :liked_airings, through: :likes, source: :likeable, :source_type => "Airing",
    order: "likes.created_at DESC"

  has_many :authorizations

  def managing_channels
    channels + collab_channels
  end

  def unwatched_feed
    Airing.where(:channel_id => following_channels).unread_by(self).reorder("airings.created_at DESC")
  end

  def all_feed
    Airing.where(:channel_id => following_channels).reorder("airings.created_at DESC")
  end


  # validations
  validates :email,
    :presence => true,
    :uniqueness => { :case_sensitive => false },
    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }

  validates :username,
    :presence => true,
    :uniqueness => { :case_sensitive => false },
    :format => {:with => /^[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*$/}


  validates_confirmation_of :password, :on => :create, :if => :password,
    :message => "should match confirmation"

  serialize :preferences, ActiveRecord::Coders::Hstore


  # callbacks
  before_validation :downcase_attributes
  before_create :setup_preferences
  before_save :clean_preferences


  def managing_channels_slugs
    managing_channels.map(&:slug).join(",")
  end

  def owns?(obj)
    self.id == obj.creator_id
  end

  def primary_channel?(channel)
    self.primary_channel == channel
  end

  def primary_channel_slug
    primary_channel.slug
  end

  def primary?(channel)
    primary_channel == channel
  end


  def email_likes?
    preferences.key? "email_likes" and preferences["email_likes"].to_i
  end

  def email_restreams?
    preferences.key? "email_restreams" and preferences["email_restreams"].to_i
  end

  def email_followers?
    preferences.key? "email_followers" and preferences["email_followers"].to_i
  end

  def setup_preferences
    preferences["email_likes"] = 1
    preferences["email_restreams"] = 1
    preferences["email_followers"] = 1
  end

  def feed_channel
    @feed ||= UserFeed.new(self)
  end

  def as_json(options={})
    options = options.merge({
      only: [:username, :primary_channel_id],
      methods: [:primary_channel_slug], includes: :channels
    })
    super(options)
  end

  private

  def clean_preferences
    preferences.delete_if {|key,value| ![:email_likes, :email_restreams, :email_followers].include? :"#{key}" }
    preferences["email_likes"] = 0 unless preferences.key? "email_likes"
    preferences["email_restreams"] = 0 unless preferences.key? "email_restreams"
    preferences["email_followers"] = 0 unless preferences.key? "email_followers"
    preferences
  end

  def downcase_attributes
    self.email = self.email.downcase if self.email.present?
    self.username = self.username.downcase if self.username.present?
  end
end
