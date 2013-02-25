class Manage::ActivitiesController < Manage::BaseController
  before_filter :set_channel

  def index
    authorize! :see_activities, @channel
    @activities = @channel.activities
  end

  private

  def set_channel
    @channel = Channel.includes(:airings => :video).find_by_slug!(params[:channel_id])
  end

  def my_channels
    @channels = current_user.channels
  end
end
