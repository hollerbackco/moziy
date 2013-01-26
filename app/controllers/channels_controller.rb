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
    @channel = params.key?(:name) ?
      Channel.find_by_slug(params[:name]) : default_channel

    if params[:v] and @channel.airings.exists? params[:v]
      @first_airing_id = params[:v]
    end

    begin
      explore_scope = Channel

      if logged_in?
        @channel_list = current_user.channel_list
        @my_channels = current_user.channels

        not_ids = @channel_list.map {|s| s.channel_id }
        not_ids = not_ids + @my_channels.map {|c| c.id}

        explore_scope = explore_scope.where("channels.id NOT IN (?)", not_ids)
      end

      @explore_channels = explore_scope.all.keep_if {|c| c.airings.any? }

      set_title @channel.title
      render :layout => "player"

    rescue MiniFB::FaceBookError
      session[:from_facebook_return_to] = request.referer
      login_at("facebook")
    end

  end

  def show_root
    if logged_in?
      redirect_to slug_path(default_channel.slug)
      return
    end

    @channel = Channel.default

    set_title @channel.title
    render :layout => "player"
  end

  def show_chromeless
    @channel = Channel.find_by_slug(params[:name])

    unless @channel.airings.count > 0
      redirect_to chromeless_path(default_channel.slug)
      return
    end

    set_title @channel.title
    render :layout => "player"
  end

  def subscribe
    channel = Channel.find(params[:id])

    if channel.subscribed_by?(current_user)
      Subscription.find_by_channel_id_and_user_id(channel.id, current_user.id).destroy

      flash[:success] = "You've removed " + channel.title
      respond_to do |format|
        format.json {render json: {subscribed: false, count: channel.subscriptions.count }}
        format.html {redirect_to channel}
      end
    else
      current_user.subscriptions.create(:channel => channel)

      flash[:success] = "You have subscribed to this channel. "
      respond_to do |format|
        format.json {render json: {subscribed: true, count: channel.subscriptions.count }}
        format.html {redirect_to slug_path(channel.slug)}
      end
    end
  end

  private

  def default_channel
    logged_in? ? current_user.subscriptions.first : Channel.default
  end

end
