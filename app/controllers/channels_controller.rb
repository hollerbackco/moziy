class ChannelsController < ApplicationController
  before_filter :require_login, :only => [:subscribe]

  def index
    @sort = params[:sort]
    case @sort
    when nil
      @user = User.new
      if logged_in?
        @channels = current_user.channel_list
      end
      @mosey_channel = Channel.default
    when 'tastemakers'
      @channels = Channel.publik
    when 'watchers'
      @channels = Channel.publik.all(:order => "subscriptions_count DESC, updated_at DESC")
    end
  end

  def show
    @channel = params.key?(:name) ? Channel.find_by_slug(params[:name]) : Channel.default

    begin
      #@channel.crawl(50) if @channel.needs_crawl?

      @explore_channels = Channel.all.keep_if {|c| c.airings.any? }

      if @channel.airings.empty?
        redirect_to new_manage_channel_video_path(@channel)
        return
      end

      @unread_channels = current_user.unread_channels.publik if logged_in?
      @channels = if logged_in?
                    current_user.read_channels.publik
                  else
                    Channel.publik.all(:order => "subscriptions_count DESC, updated_at DESC")
                  end

      @current = params[:playing] ? @channel.airings[params[:playing].to_i] : @channel.airings.first
      @previous_id = (params[:playing].to_i - 1) % @channel.airings.count
      @next_id = (params[:playing].to_i + 1) % @channel.airings.count

      set_title @channel.title
      render :layout => "player"

    rescue MiniFB::FaceBookError
      session[:from_facebook_return_to] = request.referer
      login_at("facebook")
    end
  end

  def show_chromeless
    @channel = Channel.find(params[:id])

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
