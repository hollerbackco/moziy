class ChannelMailer < ApplicationMailer

  def liked(by, from, video_title)
    @your_channel = from
    logger.info from.inspect
    logger.info from.creator
    @user = from.creator

    @their_name = by.username
    @their_channel = by.channels.first
    @video_title = video_title

    mail :to => @user.email,
         :subject => "Your video got liked."
  end

  def reaired(to, from, video_title)
    @your_channel = from
    @user = from.creator

    @their_name = to.creator.username
    @their_channel = to
    @video_title = video_title

    mail :to => @user.email,
         :subject => "Your video just went viral."
  end

  def subscribed(receiver_channel, subscriber)
    logger.info "subscribe"
    @channel = receiver_channel
    @user = receiver_channel.creator

    @subscriber = subscriber

    if @user != @subscriber
      mail :to => @user.email,
           :subject => "You are now famouser."
    end
  end

end
