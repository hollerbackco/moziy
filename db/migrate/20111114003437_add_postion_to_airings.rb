class AddPostionToAirings < ActiveRecord::Migration
  def change
    add_column :airings, :position, :integer
  end
end
