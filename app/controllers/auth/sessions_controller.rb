class Auth::SessionsController < ApplicationController
  
  before_filter :check_not_logged_in, :except => :destroy
  before_filter :require_login, :only => :destroy
  
  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      if @user = login(params[:email],params[:password],params[:remember])
        format.html { redirect_back_or_to(me_home_path, :notice => 'Login successful.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { flash.now[:alert] = "Log in failed."; render :layout => "plainjane", :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    logout
    redirect_to(login_path, :notice => 'Logged out!')
  end
  
  
end
