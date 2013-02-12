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

      ChannelMailer.commented(comment.commentable.user, comment).deliver

      render nothing: true, status: :ok
    else
      render nothing: true, status: 400
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
