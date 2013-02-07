class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # channel owner
    can :manage, Channel, :creator_id => user.id
    can :manage, Membership do |membership|
      user == membership.channel.creator
    end
    can [:manage, :archive, :delete], Airing do |airing|
      user == airing.channel.creator
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
