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
    @channel ||= Channel.find_by_slug!(params[:channel_id])
  end

end
