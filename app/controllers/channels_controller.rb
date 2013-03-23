class ChannelsController < ApplicationController
  before_filter :require_login, :only => [:subscribe]

  def index
    @channels = logged_in? ?
      Channel.publik.explore_for(current_user) :
      Channel.publik.explore

    respond_to do |format|
      format.json { render json: @channels.as_json }
    end
  end

  def feed
    if params[:v]
      @first_airing_id = params[:v]
    end

    unless logged_in?
      if @first_airing_id.present?
        @first_airing = Airing.find @first_airing_id
        redirect_to start_video_path(@first_airing.channel.slug, v: @first_airing_id)
      else
        redirect_to login_path
      end
      return
    end

    @channel_list = current_user.subscriptions
    @my_channels = current_user.channels
    @explore_channels = logged_in? ?
      Channel.publik.explore_for(current_user) :
      Channel.publik.explore

    set_title "Feed"

    render :layout => "player"
  end

  def show
    @channel = params.key?(:name) ?
      Channel.find_by_slug!(params[:name]) : nil

    if params[:v] and @channel.airings.exists? params[:v]
      @first_airing = Airing.find(params[:v])
      @first_airing_id = params[:v]
    end

    if logged_in?
      @channel_list = current_user.subscriptions
      @my_channels = current_user.channels
    end

    set_title @first_airing ? @first_airing.title : @channel.title

    if @first_airing
      set_description @first_airing.description
    end

    render :layout => "player"

  rescue ActiveRecord::RecordNotFound
    redirect_to login_path
  end

  def show_root
    if logged_in?
      redirect_to feed_path
      return
    end

    @channel = Channel.default

    set_title @channel.title
    render :layout => "player"
  end

  def show_chromeless
    @channel = Channel.find_by_slug!(params[:name])

    unless @channel.airings.count > 0
      redirect_to chromeless_path(default_channel.slug)
      return
    end

    set_title @channel.title
    render :layout => "player"

  rescue ActiveRecord::RecordNotFound
    redirect_to slug_path(Channel.default.slug)
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
      subscription = current_user.subscriptions.create(:channel => channel)

      Activity.add :channel_subscribe,
        actor: subscription.user.primary_channel,
        subject: subscription,
        secondary_subject: subscription.channel

      respond_to do |format|
        format.json {render json: {subscribed: true, count: channel.subscriptions.count }}
        format.html do
          flash[:success] = "You have subscribed to this channel. "
          redirect_to slug_path(channel.slug)
        end
      end
    end
  end

  private

  def default_channel
    channel = logged_in? ? current_user.subscriptions.first : Channel.default
    channel || Channel.default
  end
end
