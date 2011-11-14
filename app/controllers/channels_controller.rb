class ChannelsController < ApplicationController
  
  def index
    @channels = Channel.all
  end
  
  def new
    @channel = Channel.new
  end
  
  def show
    
    @channel = Channel.includes(:airings => :video).find(params[:id])
    
    unless @channel.videos.count > 0
      redirect_to new_channel_video_path(@channel)
      return
    end

    @current = params[:playing] ? @channel.videos[params[:playing].to_i] : @channel.videos.first
    @previous_id = (params[:playing].to_i - 1) % @channel.videos.count
    @next_id = (params[:playing].to_i + 1) % @channel.videos.count
  end

  def create
    @channel = Channel.new(params[:channel].merge(:owner => current_user))
    
    if @channel.save
      redirect_to @channel
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
      redirect_to edit_channel_path(@channel)
    else
      render :action => :edit
    end
  end

  def destroy
    Channel.find(params[:id]).destroy
    redirect_to :back
  end

  
end
