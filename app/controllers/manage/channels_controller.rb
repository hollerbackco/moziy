class Manage::ChannelsController < Manage::BaseController
  before_filter :set_my_channels
  before_filter :set_channel, :except => [:index,:following,:new,:create]

  def index
    channel = current_user.primary_channel
    respond_to do |format|
      format.html { redirect_to manage_channel_path channel}
      format.json { render json: current_user.channels}
    end
  end

  def following
    channel = current_user.primary_channel
    @subscriptions = current_user.subscriptions
    respond_to do |format|
      format.html { redirect_to manage_channel_path channel}
      format.json { render json: @subscriptions}
    end
  end

  def new
    @channel = Channel.new
  end

  def create
    @channel = Channel.new(params[:channel].merge(:creator => current_user))

    if @channel.save
      redirect_to manage_channel_path(@channel)
    else
      render :action => :new
    end
  end

  def show
    authorize! :see_activities, @channel
    @activities = @channel.activities
    set_title @channel.title

    render "manage/activities/index"
  end

  def edit
    authorize! :edit, @channel
  end

  def update
    authorize! :update, @channel
    if @channel.update_attributes(params[:channel])
      redirect_to edit_manage_channel_path(@channel)
    else
      render :action => :edit
    end
  end

  def destroy
    authorize! :destroy, @channel
    if !current_user.primary? @channel
      @channel.destroy
      redirect_to manage_channels_path
    else
      redirect_to manage_channel_path(@channel), alert: "You cannot delete your first channel "
    end
  end

  private

  def set_channel
    @channel = Channel.find_by_slug!(params[:id])
  end

end
