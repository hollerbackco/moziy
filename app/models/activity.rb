class Activity < ActiveRecord::Base
  belongs_to :actor, :polymorphic => true
  belongs_to :subject, :polymorphic => true, :touch => true
  belongs_to :secondary_subject, :polymorphic => true

  default_scope :order => 'activities.created_at DESC'
  scope :request, where(:event_type => :res_requested)
  scope :item_feed, where(:event_type => [:item_liked, :item_commented])
  scope :not_item_feed, where("event_type not in (?)", [:item_liked, :item_commented])

  def actor
    User.unscoped { super }
  end

  def type?(kind)
    kind == event_type
  end

  def event_type
    value = read_attribute(:event_type)
    value.blank? ? nil : value.to_sym
  end

  class << self
    def add(event_type, opts = {})
      raise ArgumentError, "Argument :subject is mandatory" unless opts.has_key?(:subject)

      unless activity = Activity.where({event_type: event_type}.merge(parse_opts(opts))).first
        activity = Activity.new(:event_type => event_type)
        activity.actor   = opts[:actor] if opts.has_key?(:actor)
        activity.subject = opts[:subject] if opts.has_key?(:subject)
        activity.secondary_subject = opts[:secondary_subject] if opts.has_key?(:secondary_subject)

        activity.save!
      end

      activity

    end


    def parse_opts(opts={})
      obj = {}
      if opts.key? :actor
        obj[:actor_id] = opts[:actor].id
        obj[:actor_type] = opts[:actor].class.name
      end
      if opts.key? :subject
        obj[:subject_id] = opts[:subject].id
        obj[:subject_type] = opts[:subject].class.name
      end
      if opts.key? :secondary_subject
        obj[:secondary_subject_id] = opts[:secondary_subject].id
        obj[:secondary_subject_type] = opts[:secondary_subject].class.name
      end
      obj
    end
  end
end
