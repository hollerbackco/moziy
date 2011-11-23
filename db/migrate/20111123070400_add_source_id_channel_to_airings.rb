class AddSourceIdChannelToAirings < ActiveRecord::Migration
  def change
    add_column :airings, :parent_id, :integer
    add_column :airings, :lft, :integer
    add_column :airings, :rgt, :integer
  end
end
