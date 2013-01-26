class InviteRequest < ActiveRecord::Base
  attr_accessible :email, :state

  validates :email, :presence => true, :uniqueness => true
  validate :already_user?

  state_machine :initial => :requested do
    event :issue do
      transition all => :issued
    end

    state :requested
    state :issued
  end

  private

  def already_user?
    if User.exists? email: email
      errors.add(:base, "email has been registered")
    end
  end
end
