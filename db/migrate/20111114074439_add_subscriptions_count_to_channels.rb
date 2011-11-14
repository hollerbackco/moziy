class AddSubscriptionsCountToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :subscriptions_count, :integer
  end
end
