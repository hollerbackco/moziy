class Manage::ContactsController < Manage::BaseController
  include AuthHelper

  def lookup
    authorization = authorization_for(params[:provider])

    channels = User.where(:email => authorization.meta).map do |u|
      u.channels.map {|channel| channel.as_json.merge(email: u.email) }
    end.flatten

    render json: {
      channels: channels,
      count: channels.count
    }
  end
end
