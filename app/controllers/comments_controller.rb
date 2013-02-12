class CommentsController < ApplicationController
  before_filter :require_login

  def create
    comment = Comment.new(
      :user => current_user,
      :actor => current_user.primary_channel,
      :commentable => airing,
      :body => params[:body]
    )

    if comment.save
      Activity.add :airing_comment,
        actor: current_user.primary_channel,
        subject: comment,
        secondary_subject: comment.commentable.channel

      airing.comment_receivers.select {|u| u != current_user}.each do |user|
        ChannelMailer.commented(user, comment).deliver
      end

      render nothing: true, status: :ok
    else
      render text: "Something went wrong", status: 400
    end
  end

  def destroy
    airing.unliked_by current_user

    render nothing: true, status: :success
  end

  private

  def airing
    @airing ||= Airing.find(params[:airing_id])
  end

end
