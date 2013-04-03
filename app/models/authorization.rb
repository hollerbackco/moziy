class Authorization < ActiveRecord::Base
  attr_accessible :access_token, :provider, :uid, :user_id, :expires_at
  serialize :meta

  belongs_to :user

  def expired?
    Time.now > expires_at
  end
end
