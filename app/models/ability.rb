class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # channel owner
    can :manage, Channel, :creator_id => user.id
    can :manage, Membership do |membership|
      membership.channel.creator == user
    end
    can :manage, Airing do |airing|
      airing.channel.creator == user
    end

    # channel members
    can [:read, :add_airing, :add_member, :see_members], Channel do |channel|
      channel.member? user
    end
    can [:archive,:delete], Airing do |airing|
      airing.user == user
    end
    can :delete, Membership do |membership|
      membership.user == user
    end
  end
end
