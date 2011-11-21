class User < ActiveRecord::Base
  attr_accessible :email, :username, :password, :password_confirmation, :authentications_attributes
  
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy
  
  accepts_nested_attributes_for :authentications
  
  has_many :channels, :foreign_key => "creator_id"
  
  has_one :facebook_channel, :class_name => "Channel::Facebook", :foreign_key => "creator_id"
  has_one :twitter_channel, :class_name => "Channel::Twitter", :foreign_key => "creator_id"
  
  has_many :subscriptions
  has_many :channel_list, :through => :subscriptions, :source => :channel
  
  def owns?(obj)
    self.id == obj.creator_id
  end
  
  def facebook
    authentications.find(:first, :conditions => {:provider => "facebook"})
  end
  
  def facebook?
    ! facebook.nil?
  end
  
  def twitter?
    authentications.find(:first, :conditions => {:provider => "twitter"})
  end
  
  def add_social(params)
    if authentications.create(params)
      logger.info params[:provider]
      case params[:provider]
      when :facebook
        logger.info "facebook"
        # todo: do this in a backround task
        channel = create_facebook_channel(:title => "#{self.facebook_channel_title}", :private => true) if facebook_channel.nil?
        channel.crawl(200)
      when :twitter
        # todo: do this in a backround task
        create_twitter_channel(:title => "personal", :private => true) if twitter_channel.nil?
      end
    end
  end
  
  def update_social(params)

    case params.delete(:provider)
    when :facebook
      if facebook.update_attributes(params)
        
        # todo: do this in a backround task
      
        # create the facebook channel if it doesn't exist
        create_facebook_channel({
          :title => facebook_channel_title, 
          :private => true}) unless facebook_channel?
        
        logger.info "facebook"
        # crawl it
        facebook_channel.crawl(50)
      end
    when :twitter
      if twitter.update_attributes(params)
        # todo: do this in a backround task
        create_twitter_channel(:title => "personal", :private => true) if twitter_channel.nil?
      end
    end
  end
    
  def has_social?(provider)
    case provider
      when "facebook" then facebook?
      when "twitter" then twitter?
    end
  end
  
  def facebook_channel?
   ! facebook_channel.nil?
  end
  
  def facebook_channel_title
    "fb-#{self.username}"
  end
  
  def twitter_channel_title
    "tw-#{self.username}"
  end
  
end
