class AddVideoRequest < ActiveRecord::Base
  attr_accessible :msg, :state, :urls, :channel, :channel_id
  belongs_to :channel

  validates :channel, presence: true

  scope :old, lambda { where("created_at < ?", (Time.now - 2.day)) }

  state_machine initial: :pending do
    event :complete do
      transition all => :success
    end
    event :error do
      transition all => :error
    end
  end
end
