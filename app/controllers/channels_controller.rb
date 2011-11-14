class ChannelsController < ApplicationController
  before_filter :require_login, :except => [:show]
  
  def index
    @channels = Channel.find(:all, :order => "subscriptions_count DESC, updated_at DESC")
  end
  
  def new
    @channel = Channel.new
  end
  
  def show
    
    @channel = Channel.includes(:airings => :video).find(params[:id])
    
    unless @channel.airings.count > 0
      redirect_to new_channel_video_path(@channel)
      return
    end

    @current = params[:playing] ? @channel.airings[params[:playing].to_i].video : @channel.airings.first.video
    @previous_id = (params[:playing].to_i - 1) % @channel.airings.count
    @next_id = (params[:playing].to_i + 1) % @channel.airings.count
  end

  def create
    @channel = Channel.new(params[:channel].merge(:creator => current_user))
    
    if @channel.save
      redirect_to @channel
    else
      render :action => :new
    end
  end

  def subscribe
    channel = Channel.find(params[:id])
    
    if channel.subscribed_by?(current_user)
      redirect_to :back
    else
      current_user.subscriptions.create(:channel => channel)
      
      flash[:success] = "You have subscribed to this channel. "
      redirect_to :back
    end
  end
  
  def unsubscribe
    
     channel = Channel.find(params[:id]) 
     
    if channel.subscribed_by?(current_user)
      Subscription.find_by_channel_id_and_user_id(channel.id, current_user.id).destroy
      
      flash[:success] = "You've removed " + channel.title

      redirect_to :back
    else
      redirect_to :back
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
