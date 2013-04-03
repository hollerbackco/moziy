class Manage::ContactsController < Manage::BaseController
  include AuthHelper

  def lookup
    authorization = authorization_for(params[:provider])

    authorization.meta = get_emails(authorization)
    authorization.save

    channels = User.where(:email => authorization.meta).map do |u|
      u.channels.map {|channel| channel.as_json.merge(email: u.email) }
    end.flatten

    render json: {
      channels: channels,
      count: channels.count
    }
  end

  private

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
