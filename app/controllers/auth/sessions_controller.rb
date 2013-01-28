class Auth::SessionsController < ApplicationController
  before_filter :check_not_logged_in, :except => :destroy
  before_filter :require_login, :only => :destroy

  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      if @user = login(params[:username],params[:password],params[:remember])
        format.html { redirect_back_or_to(root_path, :notice => 'Login successful.') }
       else
        format.html { flash.now[:alert] = "Log in failed."; render :action => "new" }
      end
    end
  end

  def destroy
    logout
    redirect_to(root_path, :notice => 'Logged out!')
  end
end
