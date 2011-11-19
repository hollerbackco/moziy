class Manage::ChannelsController < ApplicationController
  before_filter :require_login, :except => [:index, :show]
  
  def index
    @channels = current_user.channels
  end
  
  def new
    @channel = Channel.new
  end
  
  def show
    @channel = Channel.find(params[:id])
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
    @channel = Channel.find(params[:id])
  end

  def update
    @channel = Channel.find(params[:id])
    
    if @channel.update_attributes(params[:channel])
      redirect_to edit_manage_channel_path(@channel)
    else
      render :action => :edit
    end
  end

  def destroy
    Channel.find(params[:id]).destroy
    redirect_to :back
  end
  
end
