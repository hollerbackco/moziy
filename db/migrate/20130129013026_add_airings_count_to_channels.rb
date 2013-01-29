class AddAiringsCountToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :airings_count, :integer
  end
end
