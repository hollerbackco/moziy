class AddLastAddedAtToSubscriptions < ActiveRecord::Migration
  def up
    add_column :subscriptions, :last_added_airing_at, :datetime, null: false, default: Time.now
    add_index :subscriptions, :last_added_airing_at

    Subscription.all.each do |subscription|
      subscription.last_added_airing_at = subscription.updated_at
      subscription.save
    end
  end

  def down
    remove_column :subscriptions, :last_added_airing_at
  end
end
