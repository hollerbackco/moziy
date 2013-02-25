class Manage::LikesController < Manage::BaseController
  before_filter :set_my_channels, :except => [:create, :destroy]

  def index
    @videos = current_user.liked_airings
  end

  def show
    @airing = Airing.find(params[:id])
    set_title @airing.title
  end

  def create
    airing = Airing.find params[:airing_id]

    if airing.liked_by(current_user).up?
      render nothing: true, status: :ok
    else
      render nothing: true, status: 400
    end
  end

  def destroy
    airing = Airing.find params[:airing_id]

    airing.unliked_by current_user

    render nothing: true, status: :success
  end
end
