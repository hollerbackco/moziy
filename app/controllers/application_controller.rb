class ApplicationController < ActionController::Base
  protect_from_forgery

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
    redirect_to current_user if logged_in?
  end

end
