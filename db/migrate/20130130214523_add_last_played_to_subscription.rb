class AddLastPlayedToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :last_played_id, :integer
  end
end
