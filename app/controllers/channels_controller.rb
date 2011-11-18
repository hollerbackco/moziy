class ChannelsController < ApplicationController
  before_filter :require_login, :only => [:subscribe]
  
  def index
    case params[:sort]
    when nil
      @channels = Channel.all(:order => "subscriptions_count DESC, updated_at DESC")
    when 'tastemakers'
      @channels = Channel.all
    when 'favorites'
      if logged_in?
        @channels = current_user.channels
      else
        @channels = Channel.all(:order => "subscriptions_count DESC, updated_at DESC")
      end
    end
  end
  
  def show
    
    @channel = Channel.includes(:airings => :video).find(params[:id])
    
    unless @channel.airings.count > 0
      redirect_to new_manage_channel_video_path(@channel)
      return
    end
    
    unless logged_in?
      @top = Channel.all(:order => "subscriptions_count DESC, updated_at DESC") 
    end
    
    @current = params[:playing] ? @channel.airings[params[:playing].to_i].video : @channel.airings.first.video
    @previous_id = (params[:playing].to_i - 1) % @channel.airings.count
    @next_id = (params[:playing].to_i + 1) % @channel.airings.count
    
    set_title @channel.title
    render :layout => "player"
  end

  def show_chromeless
    @channel = Channel.includes(:airings => :video).find(params[:id])
    
    unless @channel.airings.count > 0
      redirect_to new_manage_channel_video_path(@channel)
      return
    end

    @current = params[:playing] ? @channel.airings[params[:playing].to_i].video : @channel.airings.first.video
    @previous_id = (params[:playing].to_i - 1) % @channel.airings.count
    @next_id = (params[:playing].to_i + 1) % @channel.airings.count
    
    set_title @channel.title
    render :layout => "player"
  end
  
  def subscribe
    channel = Channel.find(params[:id])
    
    if channel.subscribed_by?(current_user)
      Subscription.find_by_channel_id_and_user_id(channel.id, current_user.id).destroy
      
      flash[:success] = "You've removed " + channel.title
      
      redirect_to channel
    else
      current_user.subscriptions.create(:channel => channel)
      
      flash[:success] = "You have subscribed to this channel. "
      redirect_to channel
    end
  end
  

  
end
