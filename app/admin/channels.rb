ActiveAdmin.register Channel do
  index do
    column :title
    column :slug
    column :description
    column :creator
    column :airings_count do |channel|
      channel.airings.count
    end
    column :collaborators_count do |channel|
      channel.memberships.count
    end
    column :channel_invites do |channel|
      channel.channel_invites.count
    end
  end
end
