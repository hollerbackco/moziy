class Airing < ActiveRecord::Base
  acts_as_nested_set
  acts_as_readable on: :created_at

  attr_accessible :video, :channel, :parent, :video_id, :channel_id, :parent_id, :state

  has_many :likes, as: :likeable

  belongs_to :video #, :counter_cache => true
  belongs_to :channel

  validates :video_id, :presence => true
  validates :channel_id, :presence => true, :uniqueness => {:scope => [:video_id]}

  delegate :title, :source_id, :source_name, :note_count, to: :video

  after_create :increment_counts
  after_destroy :decrement_counts

  state_machine :initial => :suggestion do
    after_transition to: :archived, do: :decrement_counts
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
      likes: likes.map {|like| like.user.username },
      restreams: video.airings.map {|a| a.channel}.as_json
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

  def increment_counts
    channel.subscriptions.each{|s| s.increment_unread_count!}
  end

  def decrement_counts
    channel.subscriptions.each {|s| s.decrement_unread_count!}
  end
end
