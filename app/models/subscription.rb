class Subscription < ActiveRecord::Base
  belongs_to :channel, :counter_cache => true
  belongs_to :user

  validates :channel_id, :uniqueness => {:scope => [:user_id]}

  delegate :title, :description, :creator, :slug,  to: :channel

  after_create :update_unread_count!

  def cover_art
    channel.cover_art.as_json[:cover_art]
  end

  def creator
    channel.creator
  end

  def channel_subscribers_count
    channel.subscriptions_count
  end

  def update_unread_count!
    update_attribute(:unread_count, channel.airings.unread_by(user).count)
  end

  def as_json(options={})
    options = {
      only: [:channel_id, :unread_count],
      methods: [:channel_subscribers_count, :slug, :title, :description, :creator, :cover_art]
    }.merge options
    super
  end
end
