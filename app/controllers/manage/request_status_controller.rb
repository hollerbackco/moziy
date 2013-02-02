class Manage::RequestStatusController < Manage::BaseController

  def add_video
    req = AddVideoRequest.find params[:id]

    respond_to do |format|
      if req
        msg = {status: req.state, msg: req.msg}
        format.json{render json: msg}
      else
        msg = {status: :error, error: "Video could not be added"}
        format.json {render json: msg}
      end
    end

  end
end
