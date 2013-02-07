class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "session"

  before_filter :set_title

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
    redirect_to manage_channels_path if logged_in?
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to manage_root_url, :alert => "You are not authorized to view that page"
  end

end
