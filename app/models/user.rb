class User < ActiveRecord::Base
  attr_accessible :email, :username, :password, :password_confirmation, :authentications_attributes

  validates :email, :presence => true, :uniqueness => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }
  validates :username, :presence => true, :uniqueness => true, :format => {:with => /^[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*$/}

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

  has_many :channels, :foreign_key => "creator_id"

  has_one :facebook_channel, :class_name => "Channel::Facebook", :foreign_key => "creator_id"
  has_one :twitter_channel, :class_name => "Channel::Twitter", :foreign_key => "creator_id"

  has_many :subscriptions, order: "last_added_airing_at DESC"
  has_many :unread_subscriptions, class_name: "Subscription",
    conditions: ['unread_count > ?', 0]
  has_many :read_subscriptions, class_name: "Subscription", conditions: {unread_count: 0}

  has_many :unread_channels, through: :unread_subscriptions, source: :channel,
    order: "subscriptions.updated_at DESC"
  has_many :read_channels, through: :read_subscriptions, source: :channel,
    order: "subscriptions.created_at ASC"

  has_many :likes, order: "likes.created_at DESC"
  has_many :liked_airings, through: :likes, source: :likeable, :source_type => "Airing",
    order: "likes.created_at DESC"

  belongs_to :primary_channel, class_name: "Channel"

  def channel_list
    subscriptions
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
    options = {only: [:username], includes: :channels}.merge options
    super
  end
end
