class User < ActiveRecord::Base
  attr_accessible :email, :username, :password, :password_confirmation, :authentications_attributes, :primary_channel, :primary_channel_id

  validates :email, :presence => true, :uniqueness => { :case_sensitive => false }, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }, :format => {:with => /^[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*$/}

  before_validation :downcase_attributes

  acts_as_reader

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy do
    def find_by_provider(provider)
      find(:first, :conditions => {:provider => provider})
    end

    def connected?(provider)
      exists?({:provider => provider})
    end
  end

  accepts_nested_attributes_for :authentications

  belongs_to :primary_channel, class_name: "Channel"
  has_many :channels, :foreign_key => "creator_id", :order => "created_at ASC", :dependent => :destroy
  has_many :airings, through: :channels

  has_many :memberships
  has_many :collab_channels, through: :memberships, class_name: "Channel", source: :channel

  has_many :subscriptions, order: "last_added_airing_at DESC", :dependent => :destroy
  has_many :following_channels, through: :subscriptions, class_name: "Channel", source: :channel,
    order: "subscriptions.last_added_airing_at DESC"

  has_many :likes, order: "likes.created_at DESC"
  has_many :liked_airings, through: :likes, source: :likeable, :source_type => "Airing",
    order: "likes.created_at DESC"

  def unwatched_feed
    Airing.where(:channel_id => following_channels).unread_by(self).order("created_at DESC")
  end

  def managing_channels
    channels + collab_channels
  end

  def managing_channels_slugs
    managing_channels.map(&:slug).join(",")
  end

  def owns?(obj)
    self.id == obj.creator_id
  end

  def add_social(params)
    if authentications.create(params)

      case params[:provider]
      when :facebook
        # todo: do this in a backround task
        channel = create_facebook_channel(:title => "#{self.facebook_channel_title}", :private => true) if facebook_channel.nil?
        channel.crawl(200)
      end
    end
  end

  def update_social(params)
    case params.delete(:provider)
    when :facebook
      if authentications.find_by_provider("facebook").update_attributes(params)

        # create the facebook channel if it doesn't exist
        create_facebook_channel({
          :title => facebook_channel_title, 
          :private => true}) unless social_channel?(:facebook)

        # todo: do this in a background task
        # crawl it
        facebook_channel.crawl(50)
      end
    end
  end

  def social_channel?(provider)
    case provider
      when :twitter
      when :facebook
        ! facebook_channel.nil?
    end
  end

  def facebook_channel_title
    "fb-#{self.username}"
  end

  def twitter_channel_title
    "tw-#{self.username}"
  end

  def as_json(options={})
    options = {only: [:username, :primary_channel_id], includes: :channels}.merge options
    super
  end

  def primary?(channel)
    primary_channel == channel
  end


  private

  def downcase_attributes
    self.email = self.email.downcase if self.email.present?
    self.username = self.username.downcase if self.username.present?
  end
end
