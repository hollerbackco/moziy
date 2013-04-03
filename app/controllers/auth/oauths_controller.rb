class Auth::OauthsController < ApplicationController
  include AuthHelper

  before_filter :require_login

  def check
    if authorization = authorization_for(params[:provider])
      authorization.refresh
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
    authorization.meta          = get_emails(authorization)

    authorization.save

    render text: nil
  end

  private

  def auth
    @auth_response ||= request.env['omniauth.auth']
  end

  def get_emails(authorization)
    # contacts
    client = GContacts::Client.new(:access_token => authorization.access_token)

    all_emails = []

    client.paginate_all do |person|
      data = person.data["gd:email"] || []

      data.each do |email|
        all_emails.push email["@address"]
      end
    end

    all_emails
  end
end
