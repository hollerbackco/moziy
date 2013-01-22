class VideosController < ApplicationController
  before_filter :set_channel

  def first
    # grab the video only if it still exists in the player
    # else send the first video in the channel
    video = if logged_in?
              @channel.next_airing(nil,current_user)
            else
              @channel.airings.first
            end

    if logged_in?
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
      former_video = @channel.airings.find(params[:id])
      mark_as_read former_video
    end

    video = @channel.next_airing(params[:id], (logged_in? ? current_user : nil))

    render json: airing_json(video)
  end


  def notes
    video = @channel.airings.find(params[:id])

    render json: video.notes
  end

  private

  def mark_as_read(video)
    video.mark_as_read! for: current_user
    if @channel.subscribed_by? current_user
      @channel.subscription_for(current_user).update_unread_count!
    end
  end

  def airing_json(video)
    {
     :id => video.id,
     :source_name => video.source_name,
     :source_id => video.source_id,
     :title => video.title,
     :channel_id => video.channel_id,
     :note_count => video.note_count,
     :parent => video.parent.as_json(:include => [:channel])
    }
  end

  def set_channel
    @channel = Channel.includes(:airings => :video).find(params[:channel_id])
  end
end
