class Airing < ActiveRecord::Base
  acts_as_nested_set
  acts_as_readable on: :created_at

  attr_accessible :video, :channel, :parent, :video_id, :channel_id,
    :parent_id, :state, :position, :user_id, :content

  has_many :attachments, class_name: "Activity", as: :subject, order: "created_at DESC"
  has_many :likes,    as: :likeable
  has_many :comments, as: :commentable, order: "created_at DESC"
  has_many :commenters, through: :comments, source: :user

  belongs_to :video #, :counter_cache => true
  belongs_to :channel
  belongs_to :user

  validates :video_id, :presence => true
  validates :channel_id, :presence => true, :uniqueness => {:scope => [:video_id]}

  delegate :title, :description, :source_id, :source_name, to: :video

  before_create :set_position_to_default
  after_create :increment_counts
  after_destroy :decrement_counts

  scope :since, lambda { |since| where("airings.created_at > ?", since) }

  def self.next(airing)
    where("airings.created_at < ?", airing.created_at).first
  end

  state_machine :initial => :live do
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

  def comment_receivers
   (channel.parties + commenters).uniq
  end

  def history
    top_node = root? ? self : root
    Activity.where("(subject_type = 'Airing' and subject_id IN (?)) or (subject_type = 'Comment' and subject_id IN (?))", top_node.self_and_descendants, comments)
    #Activity.where(:subject_id => top_node.self_and_descendants, :subject_type => "Airing")
  end

  def note_count
    top_node = root? ? self : root
    likes.count + top_node.self_and_descendants.count
  end

  def notes
    top_node = root? ? self : root
    channels = top_node.descendants.map {|a| {type: "Restream", channel: a.channel} }
    channels = channels + likes.map {|like| {type: "Like", channel: like.user.primary_channel} }
    channels = channels + [{type: "Add", channel: top_node.channel}]
    channels = channels + comments.map {|comment| {type: "Comment", channel: comment.user.primary_channel, body: comment.body} }
    channels.as_json
  end

  def liked_by?(user)
    like = likes.find_by_user_id(user.id)

    like.present?
  end

  def liked_by(user)
    like = likes.find_by_user_id(user.id)

    unless like
      like = likes.create(user: user)
    end

    if like.up
      Activity.add :airing_like,
        actor: like.user.primary_channel,
        subject: like.likeable,
        secondary_subject: like.likeable.channel
    end

    like
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
    channel.save
  end

  def decrement_counts
    channel.subscriptions.each {|s| s.decrement_unread_count!}
    channel.save
  end

  def set_position_to_default
    self.position = 0
  end
end
