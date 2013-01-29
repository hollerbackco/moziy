class SettingsController < Manage::BaseController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_attributes params[:user]
      redirect_to settings_path
    else
      render :edit
    end
  end
end
