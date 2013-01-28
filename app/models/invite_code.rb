class InviteCode < ActiveRecord::Base
  attr_accessible :code, :state

  belongs_to :user
  validates :code, presence: true, uniqueness: true

  before_validation :generate_code, on: :create

  scope :not_used, where("state NOT IN (?)", "used")

  state_machine initial: :generated do
    event :issue do
      transition all => :issued
    end
    event :use do
      transition all => :used
    end
  end

  def generate_code
    begin
      webster = Webster.new
      self.code = webster.random_word
    end while self.class.exists?(code: self.code)
  end
end
