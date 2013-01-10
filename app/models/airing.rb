class Airing < ActiveRecord::Base
  acts_as_nested_set
  acts_as_readable on: :created_at

  attr_accessible :video, :channel, :video_id, :channel_id, :parent_id, :state

  has_many :likes, as: :likeable

  belongs_to :video #, :counter_cache => true
  belongs_to :channel

  validates :video_id, :presence => true
  validates :channel_id, :presence => true, :uniqueness => {:scope => [:video_id]}

  delegate :title, :source_id, :source_name, :note_count, to: :video

  after_create :update_subscription_unread_count
  after_destroy :update_subscription_unread_count

  state_machine :initial => :suggestion do
    after_transition to: :archived, do: :update_subscription_unread_count
    event :go_live do
      transition all => :live
    end

    event :toggle_archive do
      transition :archived => :live
      transition all - :archived => :archived
    end

    state :suggestion
    state :live
    state :archived
  end

  def notes
    {
      likes: likes,
      restreams: video.airings.map {|a| a.channel}
    }
  end

  def liked_by(user)
    if like = likes.find_by_user_id(user.id)
      like.up
    else
      likes.create(user: user).up
    end
  end

  def unliked_by(user)
    if like = likes.find_by_user_id(user.id)
      like.down
    end
  end

  def self.sort(ids)
    update_all(
      ["position = STRPOS(?, ','||video_id||',')", ",#{ids.join(',')},"], 
      { :video_id => ids }
    )
  end

  private

  def update_subscription_unread_count
    channel.subscriptions.each{|s| s.update_unread_count!}
  end
end
