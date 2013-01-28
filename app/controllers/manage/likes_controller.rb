class Manage::LikesController < Manage::BaseController
  before_filter :set_my_channels

  def index
    @videos = current_user.liked_airings
  end

  def show
    @airing = Airing.find(params[:id])
    set_title @airing.title
  end
end
