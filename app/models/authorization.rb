class Authorization < ActiveRecord::Base
  attr_accessible :access_token, :meta, :provider, :uid, :user_id

  belongs_to :user
end
