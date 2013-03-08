class Feed < ActiveRecord::Base
  attr_accessible :feed_type, :slug, :source_name, :source_url

  FEED_TYPES = [:website, :youtube, :vimeo]

  # scopes for the feed types
  FEED_TYPES.each do |feed_type|
    scope :"#{feed_type}", where(:feed_type => feed_type)
  end

  validates :slug, presence: true, uniqueness: {scope: [:feed_type, :source_name, :source_url]}
  validates :feed_type, presence: true

  def user
    user = Channel.default.creator
  end

  def channel
    @channel = user.channels.where(slug: slug).first_or_create do |channel|
      channel.slug = slug
      channel.title = slug
    end
  end

  def feed_performer
    case feed_type.to_sym
    when :website
      Moziy::Feeder::Website.new(self)
    when :youtube
      Moziy::Feeder::Youtube.new(self)
    when :vimeo
      Moziy::Feeder::Vimeo.new(self)
    else
      raise InvalidFeedType
    end
  end

  class InvalidFeedType < StandardError; end
end
