class InvitesController < ApplicationController
  before_filter :check_for_mobile, :only => [:new, :create]

  def new
    @invite = InviteRequest.new
  end

  def create
    email = params[:email] || params[:invite_request][:email]
    @invite = InviteRequest.new(email: email)
    respond_to do |format|
      if @invite.save
        format.html do
          flash[:notice] = "thanks"
          redirect_to new_invite_path
        end
        format.json { render json: {success: true} }
      else
        format.html do
          render :action => :new
        end
        format.json do
          render json: {success: false, errors: @invite.errors.full_messages}
        end
      end
    end
  end
end
