class Auth::OauthsController < ApplicationController
  before_filter :require_login

  def check
    msg = {
      authorized: authorization_for(params[:provider]).present?,
      service: params[:provider]
    }

    render json: msg
  end

  def callback
    render text: auth.inspect
  end

  private

  def auth
    @auth_response ||= request.env['rack.auth']
  end

  def authorization_for(provider)
    @authorization ||= current_user.authorizations.find_by_provider(provider)
  end
end
