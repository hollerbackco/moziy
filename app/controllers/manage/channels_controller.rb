class Manage::ChannelsController < ApplicationController
  before_filter :require_login, :except => [:index, :show]
  before_filter :check_ownership, :except => [:index, :new, :create]
  before_filter :my_channels

  def index
    @channels = current_user.channels.publik
  end

  def new
    @channel = Channel.new
  end

  def show
  end

  def create
    @channel = Channel.new(params[:channel].merge(:creator => current_user))

    if @channel.save
      redirect_to new_manage_channel_video_path(@channel)
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
    @channel.destroy
    redirect_to manage_channels_path
  end

  private

    def check_ownership
      @channel = Channel.find(params[:id])
      redirect_to root_path unless current_user.owns? @channel
    end

    def my_channels
      @channels = current_user.channels
    end

end
