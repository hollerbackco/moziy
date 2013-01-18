class Manage::LikesController < Manage::BaseController
  before_filter :set_my_channels

  def index
    @videos = current_user.liked_airings
  end
end
