class ChannelInvite < ActiveRecord::Base
  attr_accessible :channel_id, :recipient_email, :sender_id, :sent_at, :token

  validates :recipient_email, :presence => true, :uniqueness => { :case_sensitive => false, :scope => [:channel_id] }, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }

  belongs_to :channel
  belongs_to :sender, class_name: "User"

  before_create :generate_token

  private

  def generate_token
    begin
      self.token = SecureRandom.urlsafe_base64(8)
    end while self.class.exists?(token: self.token)
  end
end
