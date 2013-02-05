class ChannelMailer < ApplicationMailer

  def liked(channel, likes)
    @your_channel = channel
    @user = channel.creator
    @likes = likes

    subject = "#{likers_string @likes} liked #{@your_channel.slug}"

    mail to: @user.email, subject: subject
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
    @subscriber_channel = subscriber.primary_channel

    if @user != @subscriber
      mail :to => @user.email,
           :subject => "You are now famouser."
    end
  end

  def invite(invite)
    @token = invite.token
    @channel = invite.channel
    @recipient = invite.recipient_email
    @sender = invite.sender

    mail :to => @recipient,
         :subject => "#{@sender.username} has invited you to join a stream"
  end

  private

  def likers_string(likes)
    string = "#{likes.first.user.username}"

    if likes.count > 1
      string = "#{string} and #{likes.count - 1} others"
    end

    string
  end

end
