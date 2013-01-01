class ChannelMailer < ApplicationMailer

  def liked(by, from, video_title)
    @your_channel = from
    @user = from.creator

    @their_name = by.username
    @their_channel = by.channels.first
    @video_title = video_title

    mail :to => @user.email,
         :subject => "#{@their_name} just highfived your video."
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
    @channel = receiver_channel
    @user = receiver_channel.creator

    @subscriber = subscriber

    if @user != @subscriber
      mail :to => @user.email,
           :subject => "You are now famouser."
    end
  end

end
