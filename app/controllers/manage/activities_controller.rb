class Manage::ActivitiesController < Manage::BaseController
  before_filter :set_channel
  before_filter :check_ownership

  def index
    @activities = @channel.activities
  end

  private

  def set_channel
    @channel = Channel.includes(:airings => :video).find(params[:channel_id])
  end

  def check_ownership
    redirect_to root_path unless current_user.owns?(@channel)
  end

  def my_channels
    @channels = current_user.channels
  end
end
