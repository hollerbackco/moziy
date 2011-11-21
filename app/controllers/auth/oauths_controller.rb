class Auth::OauthsController < ApplicationController
      
  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(params[:provider])
  end
      
  def callback
    provider = params[:provider]
    
    if @user = current_user
      create_auth(provider)
      if back = session["from_#{provider}_return_to".to_sym]
        console.log back
        redirect_to back
        session["from_#{provider}_return_to".to_sym] = nil
      else
        begin
          redirect_to @user.facebook_channel, :notice => "Logged in from #{provider.titleize}!"
        rescue
          redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
        end
      end
    end
  end

  
  private
  
    def create_auth(provider)
      provider = provider.to_sym
      @provider = Config.send(provider)
      @token = @provider.process_callback(params,session).token
      @user_hash = @provider.get_user_hash
      
      if @user.authentications.connected?(provider.to_s)
        @user.update_social({:uid => @user_hash[:uid], :token => @token, :provider => provider})
      else
        @user.add_social({
          :provider => provider, 
          :uid => @user_hash[:uid],
          :token => @token})
      end
    end
end
