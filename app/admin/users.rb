ActiveAdmin.register User do
  index do
    column :id
    column :username
    column :email
    column :channels do |user|
      user.managing_channels_slugs
    end
  end
end
