class Manage::FeedController < Manage::BaseController
  include AiringsHelper

  before_filter :require_login

  def first
    video = if params.key? :airing_id
              Airing.find params[:airing_id]
            else
              current_user.feed_channel.get
            end

    render json: airing_json(video)
  end

  def next
    video = current_user.feed_channel.get(offset_id: params[:id])

    render json: airing_json(video)
  end

end
