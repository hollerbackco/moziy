class FeedController < ApplicationController
  include AiringsHelper

  before_filter :require_login

  def first
    video = current_user.feed_channel.get

    render json: airing_json(video)
  end

  def next
    video = current_user.feed_channel.get(offset_id: params[:id])

    render json: airing_json(video)
  end

end
