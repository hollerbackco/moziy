class ChannelMailer < ApplicationMailer

  def liked(recipient, channel, likes)
    @your_channel = channel
    @user = recipient

    if ! @user.email_likes?
      return
    end

    @likes = likes
    @users = likes.map(&:user)

    subject = "#{usernames_string @users} pratically highfived your video"

    mail to: @user.email, subject: subject
  end

  def commented(recipient, comment)
    @user = recipient
    @comment = comment
    @airing = comment.commentable
    @speaker = comment.user

    subject = "/#{@speaker.username} commented on #{@airing.title}"

    mail to: @user.email, subject: subject
  end

  def added(recipient, channel, airings)
    @your_channel = channel
    @user = recipient

    @airings = airings
    @users = airings.map(&:user)

    subject = "#{usernames_string @users} added videos to /#{@your_channel.slug}"

    mail to: @user.email, subject: subject
  end

  def reaired(to, from, video_title)
    @your_channel = from
    @user = from.creator

    if ! @user.email_restreams?
      return
    end

    @their_name = to.creator.username
    @their_channel = to
    @video_title = video_title

    mail :to => @user.email,
         :subject => "Your video just went viral."
  end

  def subscribed(receiver_channel, subscriber)
    @channel = receiver_channel
    @user = receiver_channel.creator

    if ! @user.email_followers?
      return
    end

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
      string = "#{string}"
    end

    string
  end

end
