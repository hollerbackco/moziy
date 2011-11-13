class CreateUsersChannelsJoinTable < ActiveRecord::Migration
  def up
    create_table :users_channels, :id => false do |t|
      t.integer :user_id
      t.integer :channel_id
    end
  end

  def down
  end
end
