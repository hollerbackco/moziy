class Manage::FollowersController < Manage::BaseController

  def index
    authorize! :see_followers, channel
    @members = channel.subscribers
  end

  private

  def user
    @user ||= current_user
  end

  def channel
    @channel ||= Channel.find(params[:channel_id])
  end

end
