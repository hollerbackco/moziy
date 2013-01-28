class InviteCode < ActiveRecord::Base
  attr_accessible :code
  validates :code, presence: true, uniqueness: true

  before_validation :generate_code, on: :create

  def generate_code
    begin
      webster = Webster.new
      self.code = webster.random_word
    end while self.class.exists?(code: self.code)
  end
end
