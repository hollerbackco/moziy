class User < ActiveRecord::Base
  attr_accessible :email, :username, :password, :password_confirmation, :authentications_attributes
  
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
  
  has_many :subscriptions
  has_many :channel_list, :through => :subscriptions, :source => :channel
  
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
          :private => true}) unless facebook_channel?
          
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
  
end
