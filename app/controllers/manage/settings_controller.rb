class Manage::SettingsController < Manage::BaseController
  before_filter :set_my_channels

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_attributes params[:user]
      channel = @user.primary_channel
      channel.slug = @user.username
      channel.save
      redirect_to manage_settings_path, notice: "settings updated"
    else
      render :edit
    end
  end


  def clean_params
    user_params = params[:user]

    preferences = user_params.delete :preferences

    user_params[:preferences] = preferences.inject({}) {|memo, word| memo[word[0]] = word[1].to_i; memo}

    logger.info user_params[:preferences]
    user_params
  end
end
