class Authorization < ActiveRecord::Base
  attr_accessible :access_token, :provider, :uid, :user_id, :expires_at
  serialize :meta

  belongs_to :user

  def expired?
    DateTime.now > self.expires_at
  end
end
