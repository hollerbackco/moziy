class VideosController < ApplicationController
  include AiringsHelper

  before_filter :set_channel

  def first
    # grab the video only if it still exists in the player
    # else send the first video in the channel
    video = if logged_in?
              @channel.next_airing(nil,current_user)
            else
              @channel.airings.first
            end

    if logged_in? and video
      mark_as_read video
    end

    render json: airing_json(video)
  end

  def show
    video = @channel.airings.find params[:id]

    if logged_in?
      mark_as_read video
    end

    render json: airing_json(video)
  end

  def next
    if logged_in?
      if former_video = @channel.airings.find(params[:id])
        mark_as_read former_video
      end
    end

    video = @channel.next_airing(params[:id], (logged_in? ? current_user : nil))

    render json: airing_json(video)
  end

  def notes
    video = @channel.airings.find(params[:id])
    render json: {notes: video.notes}
  end

  private

  def set_channel
    @channel = Channel.includes(:airings => :video).find(params[:channel_id])
  end
end
