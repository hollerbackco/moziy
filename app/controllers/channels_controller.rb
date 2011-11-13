class ChannelsController < ApplicationController
  
  def index
    @channels = Channel.all
  end
  
  def new
    @channel = Channel.new
  end
  
  def show
    
    @channel = Channel.find(params[:id])
    
    unless @channel.videos.count > 0
      redirect_to new_channel_video_path(@channel)
      return
    end
    
    @channel = Channel.find(params[:id])
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
  end

  def update
  end

  def destroy
  end
  
  

end
