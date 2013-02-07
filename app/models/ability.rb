class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # channel owner
    can :manage, Channel, :creator_id => user.id
    can :manage, Membership do |membership|
      user.id == membership.channel.creator_id
    end
    can [:manage, :archive, :delete], Airing do |airing|
      user.id == airing.channel.creator_id
    end

    # channel members
    can [:read, :add_airing, :add_member, :see_members, :see_activities], Channel do |channel|
      channel.member? user
    end
    can [:edit], Airing do |airing|
      airing.channel.member? user
    end
    can [:archive,:delete], Airing do |airing|
      user.id == airing.user_id
    end
    can :delete, Membership do |membership|
      user.id == membership.user_id
    end
  end
end
