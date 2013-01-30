class CreateActivities < ActiveRecord::Migration

  class Activity < ActiveRecord::Base
    self.record_timestamps = false
    belongs_to :actor, polymorphic: true
    belongs_to :subject, polymorphic: true
    belongs_to :secondary_subject, polymorphic: true

    def self.add(event_type, opts = {})
      raise ArgumentError, "Argument :subject is mandatory" unless opts.has_key?(:subject)

      activity = Activity.new(:event_type => event_type)
      activity.actor   = opts[:actor] if opts.has_key?(:actor)
      activity.subject = opts[:subject] if opts.has_key?(:subject)
      activity.secondary_subject = opts[:secondary_subject] if opts.has_key?(:secondary_subject)

      activity
    end
  end

  def up
    create_table :activities do |t|
      t.string   "event_type"
      t.string   "subject_type"
      t.string   "actor_type"
      t.string   "secondary_subject_type"
      t.integer  "subject_id"
      t.integer  "actor_id"
      t.integer  "secondary_subject_id"
      t.timestamps
    end

    add_index "activities", ["actor_id", "actor_type"]
    add_index "activities", ["subject_id", "subject_type"]
    add_index "activities", ["secondary_subject_id", "secondary_subject_type"], name: "index_activities_on_secondary_subject_id_and_type"

    add_activities_for_adds
    add_activities_for_restreams
    add_activities_for_likes
    add_activities_for_followers
  end

  def down
    drop_table :activities
  end

  def add_activities_for_adds
    Airing.roots.each do |airing|
      a = Activity.add :airing_add, actor: airing.channel, subject: airing
      a.created_at = airing.created_at
      a.updated_at = airing.updated_at
      a.save
    end
  end

  def add_activities_for_restreams
    Airing.where("airings.parent_id is not null").all.each do |restream|
      a = Activity.add :airing_restream, actor: restream.channel, subject: restream, secondary_subject: restream.parent.channel
      a.created_at = restream.created_at
      a.updated_at = restream.updated_at
      a.save
    end
  end

  def add_activities_for_likes
    Like.all.each do |like|
      a = Activity.add :airing_like, actor: like.user.primary_channel, subject: like.likeable, secondary_subject: like.likeable.channel
      a.created_at = like.created_at
      a.updated_at = like.updated_at
      a.save
    end
  end

  def add_activities_for_followers
    Subscription.all.each do |subscription|
      a = Activity.add :channel_subscribe, actor: subscription.user.primary_channel, subject: subscription, secondary_subject: subscription.channel
      a.created_at = subscription.created_at
      a.updated_at = subscription.updated_at
      a.save
    end
  end
end

