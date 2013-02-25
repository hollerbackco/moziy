if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.mandrillapp.com',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['MANDRILL_USERNAME'],
    :password       => ENV['MANDRILL_APIKEY'],
    :domain         => 'heroku.com'
  }
  ActionMailer::Base.delivery_method = :smtp

elsif Rails.env.staging?
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.mandrillapp.com',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['MANDRILL_USERNAME'],
    :password       => ENV['MANDRILL_APIKEY'],
    :domain         => 'heroku.com'
  }
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.register_interceptor(PreventMailInterceptor)

elsif Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    :address => "localhost",
    :port => 1025
  }
  ActionMailer::Base.delivery_method = :smtp
end
