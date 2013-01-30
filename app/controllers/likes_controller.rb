class LikesController < ApplicationController
  before_filter :require_login

  def create
    airing = channel.airings.find params[:airing_id]

    if airing.liked_by(current_user).up?
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

  def channel
    @channel ||= Channel.find(params[:channel_id])
  end

end
