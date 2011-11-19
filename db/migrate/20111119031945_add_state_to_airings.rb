class AddStateToAirings < ActiveRecord::Migration
  def change
    add_column :airings, :state, :string
  end
end
