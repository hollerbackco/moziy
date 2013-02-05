class ChannelInvite < ActiveRecord::Base
  attr_accessible :channel_id, :recepient_email, :sender_id, :sent_at, :token

  validates :recepient_email, :presence => true, :uniqueness => { :case_sensitive => false, :scope => [:channel_id] }, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }

  belongs_to :channel
  belongs_to :sender, class_name: "User"

  before_create :generate_token

  private

  def generate_token
    begin
      self.token = ReadableRandom.base64(8)
    end while self.class.exists?(token: self.token)
  end
end