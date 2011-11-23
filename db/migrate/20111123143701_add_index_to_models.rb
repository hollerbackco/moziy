class AddIndexToModels < ActiveRecord::Migration
  def change
    add_index :airings, :channel_id
    add_index :airing, :position
   
    add_index :authentications, :user_id
    add_index :channels, :creator_id
    add_index :subscriptions, :user_id
  end
end
