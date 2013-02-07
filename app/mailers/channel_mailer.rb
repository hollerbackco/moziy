class ChannelMailer < ApplicationMailer

  def liked(channel, likes)
    @your_channel = channel
    @user = channel.creator
    @likes = likes
    @users = likes.map(&:user)

    subject = "#{usernames_string @users} liked #{@your_channel.slug}"

    mail to: @your_channel.parties.map(&:email), subject: subject
  end

  def added(recipient, channel, airings)
    @your_channel = channel
    @user = recipient
    @airings = airings
    @users = airings.map(&:user)

    subject = "#{usernames_string @users} added videos to #{@your_channel.slug}"

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

  def usernames_string(users)
    usernames = users.map(&:username).uniq

    string = "#{usernames.pop}"
    if usernames.any?
      string = "#{string} and #{usernames.count - 1} others"
    end

    string
  end

end
