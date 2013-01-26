class InvitesController < ApplicationController
  def create
    invite = InviteRequest.new(email: params[:email])
    respond_to do |format|
      if invite.save
        format.json { render json: {success: true} }
      else
        format.json do
          render json: {success: false, errors: invite.errors.full_messages}
        end
      end
    end
  end
end
