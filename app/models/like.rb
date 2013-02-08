class Like < ActiveRecord::Base
  attr_accessible :like_flag, :likeable_id, :likeable_type, :user_id, :user

  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates_presence_of :user_id
  validates_presence_of :likeable_id

  scope :since, lambda { |since| where("likes.created_at > ?", since) }

  def up
    update_attribute(:like_flag, true)
  end

  def up?
    like_flag
  end

  def down
    update_attribute(:like_flag, false)
  end
end
