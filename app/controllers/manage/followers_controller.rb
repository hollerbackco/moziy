class Manage::FollowersController < Manage::BaseController
  def index
    authorize! :see_followers, channel
    @channels = channel.subscribers.map {|c| c.primary_channel }
  end

  def following
    @channels = current_user.following_channels
    render "channels"
  end

  private

  def user
    @user ||= current_user
  end

  def channel
    @channel ||= Channel.find_by_slug!(params[:channel_id])
  end

end
