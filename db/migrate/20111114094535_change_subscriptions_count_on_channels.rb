class ChangeSubscriptionsCountOnChannels < ActiveRecord::Migration
  def up
    change_column(:channels, :subscriptions_count, :integer, :default => 0)
  end

  def down
  end
end
