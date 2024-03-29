#intercom
IntercomRails.config do |config|
  # == Intercom app_id
  #
  config.app_id = ENV["INTERCOM_APP_ID"] || "dwv93v36"

  # == Intercom secret key 
  # This is reuqired to enable secure mode, you can find it on your Intercom 
  # "security" configuration page.
  #
  config.api_secret = ENV["INTERCOM_API_SECRET"] || "0bjV7Wv1D4waXfIitjouD9jJO4WLAoypjgGEo5P2"

  # == Intercom API Key
  # This is required for some Intercom rake tasks like importing your users;
  # you can generate one at https://www.intercom.io/apps/api_keys.
  #
  config.api_key = ENV["INTERCOM_API_KEY"] || "b952c2c21517e3214067593edcfc146ccc8cf50d"

  # == Curent user name
  # The method/variable that contains the logged in user in your controllers.
  # If it is `current_user` or `@user`, then you can ignore this
  #
  # config.user.current = Proc.new { current_user }

  # == User model class
  # The class which defines your user model
  #
  # config.user.model = Proc.new { User }

  # == User Custom Data
  # A hash of additional data you wish to send about your users.
  # You can provide either a method name which will be sent to the current
  # user object, or a Proc which will be passed the current user.
  #
  # config.user.custom_data = {
  #   :plan => Proc.new { |current_user| current_user.plan.name },
  #   :favorite_color => :favorite_color
  # }

  config.user.custom_data = {
    channel_count: Proc.new { |user| user.channels.count },
    airings_count: Proc.new { |user| user.airings.count },
    likes_count: Proc.new { |user| user.likes.count },
    following_count: Proc.new { |user| user.subscriptions.count },
    primary_channel: Proc.new { |user| user.primary_channel.slug }
  }


  # == Inbox Style
  # This enables the Intercom inbox which allows your users to read their
  # past conversations with your app, as well as start new ones. It is 
  # disabled by default.
  #   * :default shows a small tab with a question mark icon on it
  #   * :custom attaches the inbox open event to an anchor with an
  #             id of #Intercom.
  #
  # config.inbox.style = :default
  # config.inbox.style = :custom

  # == Inbox Counter
  # If you're using the custom inbox style, you can request that Intercom
  # insert an `em` element into your anchor with the count of unread messages
  #
  # config.inbox.counter = true

end

#mixpanel
Rails.configuration.mixpanel_key = ENV["MIXPANEL_APP_ID"] || "6e0b5b5917fea0e3ebaaaaceff55c892"

#google
Rails.configuration.ga_key = ENV["GA_APP_ID"] || "UA-27201002-2"
