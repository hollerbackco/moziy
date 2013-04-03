class Auth::OauthsController < ApplicationController
  include AuthHelper

  before_filter :require_login

  def check
    if authorization = authorization_for(params[:provider])
      if authorization.expired?
        authorization.destroy
        authorization = nil
      end
    end

    msg = {
      authorized: authorization.present?,
      service: params[:provider]
    }

    render json: msg
  end

  def callback
    if authorization = authorization_for(params[:provider])
      #authorization.refresh
    else
      authorization = current_user.authorizations.create(provider: params[:provider])
    end

    authorization.access_token  = auth[:credentials][:token]
    authorization.expires_at    = DateTime.strptime(auth[:credentials][:expires_at].to_s, "%s")
    authorization.save

    render text: nil
  end


  private

  def auth
    @auth_response ||= request.env['omniauth.auth']
  end

end
