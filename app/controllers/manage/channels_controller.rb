class Manage::ChannelsController < Manage::BaseController
  before_filter :set_my_channels
  before_filter :check_ownership, :except => [:index,:following, :new, :create]

  def index
    channel = current_user.primary_channel
    respond_to do |format|
      format.html { redirect_to manage_channel_path channel}
      format.json { render json: @channels}
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

  def show
    set_title @channel.title
    @videos = @channel.videos
  end

  def create
    @channel = Channel.new(params[:channel].merge(:creator => current_user))

    if @channel.save
      redirect_to manage_channel_videos_path(@channel)
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @channel.update_attributes(params[:channel])
      redirect_to edit_manage_channel_path(@channel)
    else
      render :action => :edit
    end
  end

  def destroy
    if !current_user.primary? @channel
      @channel.destroy
      redirect_to manage_channels_path
    else
      redirect_to manage_channel_path(@channel), alert: "You cannot delete your first channel "
    end
  end

  private

  def check_ownership
    @channel = Channel.find(params[:id])
    redirect_to root_path unless current_user.owns? @channel
  end

end
