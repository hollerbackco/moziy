class VideosController < ApplicationController
  before_filter :set_channel

  def show
    # grab the video only if it still exists in the player
    # else send the first video in the channel
    video = if logged_in?
              @channel.next_airing(params[:id],current_user)
            elsif @channel.airings.exists? params[:id]
              @channel.airings.find(params[:id])
            else
              @channel.airings.first
            end

    if logged_in?
      video.mark_as_read! for: current_user
      @channel.subscription_for(current_user).update_unread_count! if @channel.subscribed_by? current_user
    end

    re = {
       :id => video.id,
       :source_name => video.source_name,
       :source_id => video.source_id,
       :title => video.title
      }

    render :json => re
  end

  def next
    video = @channel.next_airing(params[:id], (logged_in? ? current_user : nil))

    if logged_in?
      former_video = @channel.airings.find(params[:id])
      former_video.mark_as_read! for: current_user
      @channel.subscription_for(current_user).update_unread_count! if @channel.subscribed_by? current_user
    end

    re = {
       :id => video.id,
       :source_name => video.source_name,
       :source_id => video.source_id,
       :title => video.title
      }

    render :json => re
  end

  private

    def check_regex(s)
      embedly_re = Regexp.new(/((http:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|youtu\.be\/.*|.*\.youtube\.com\/user\/.*|.*\.youtube\.com\/.*#.*\/.*|m\.youtube\.com\/watch.*|m\.youtube\.com\/index.*|.*\.youtube\.com\/profile.*|.*\.youtube\.com\/view_play_list.*|.*\.youtube\.com\/playlist.*|www\.vimeo\.com\/groups\/.*\/videos\/.*|www\.vimeo\.com\/.*|vimeo\.com\/groups\/.*\/videos\/.*|vimeo\.com\/.*|vimeo\.com\/m\/#\/.*))|(https:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*)))/i)
      s.match(embedly_re)
    end

    def set_channel
      @channel = Channel.includes(:airings => :video).find(params[:channel_id])
    end

end
