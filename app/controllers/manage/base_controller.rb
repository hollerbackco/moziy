class Manage::BaseController < ActionController::Base
  protect_from_forgery

  layout "application"
  before_filter :set_title
  before_filter :require_login
  before_filter :set_my_channels

  # excepts a string:title
  # =>  if title, use the string as the page title
  # =>  if title = nil, define in locatization. using the controller.action.title. 
  def set_title(title = nil)
     @title = [!title, title || "#{controller_name}.#{action_name}.title"]
  end

  def not_authenticated
    redirect_to login_path, :alert => "Please login first."
  end

  def check_not_logged_in
    redirect_to current_user if logged_in?
  end

  def set_my_channels
    @channels = current_user.following_channels
  end
end
