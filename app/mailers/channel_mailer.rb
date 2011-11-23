class ChannelMailer < ApplicationMailer
  
  def reaired(to, from, video_title)
    @your_channel = from
    @user = from.creator
    
    @their_name = to.creator.username
    @their_channel = to
    @video_title = video_title
    
    
    mail :to => "jnoh12388@gmail.com",
         :subject => "Your video just went viral."
  end
  
  def subscribed(receiver_channel, subscriber)
    logger.info "subscribe"
    @channel = receiver_channel
    @user = receiver_channel.creator
    
    @subscriber = subscriber
    
    if @user != @subscriber
      mail :to => "jnoh12388@gmail.com",
           :subject => "You are now famouser."
    end
  end
  
end
