class AddUserToAirings < ActiveRecord::Migration
  def up
    add_column :airings, :user_id, :integer
    update_airings_with_users
  end

  def down
    remove_column :airings, :user_id
  end

  def update_airings_with_users
    Airing.record_timestamps = false
    Airing.all.each do |airing|
      if airing.channel.present?
        airing.user = airing.channel.creator
        airing.save!
        airing.go_live!
      end
    end
  end
end
