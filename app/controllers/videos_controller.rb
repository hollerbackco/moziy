class VideosController < ApplicationController
  before_filter :set_channel

  def show
    # grab the video only if it still exists in the player
    # else send the first video in the channel
    video = @channel.airings.exists?(params[:id]) ? @channel.airings.find(params[:id]) : @channel.airings.first

    re = {
       :id => video.id,
       :source_name => video.source_name,
       :source_id => video.source_id,
       :title => video.title
      }

    render :json => re
  end

  def next
    video = @channel.next_airing(params[:id])

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
