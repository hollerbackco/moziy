class AddPrimaryChannelToUser < ActiveRecord::Migration
  def change
    add_column :users, :primary_channel_id, :integer
  end
end
