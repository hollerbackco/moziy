class ChannelMailer < ApplicationMailer
  default :from => "do-not-reply@mosey.tv"
  
  def reaired(channel, source, video_title)
    @your_channel = source
    @their_name = channel.creator.username
    @their_channel = channel
    @video_title = video_title
    
    @user = channel.creator
    mail :to => @user.email,
         :subject => "Your video just went viral."
  end
  
  def subscribed(receiver_channel, subscriber)
    
    @channel = receiver_channel
    @user = receiver_channel.creator
    
    @subscriber = subscriber

    mail :to => @user.email,
         :subject => "You are now famouser."
  end
  
end
