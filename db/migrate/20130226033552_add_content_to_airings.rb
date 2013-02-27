class AddContentToAirings < ActiveRecord::Migration
  def change
    add_column :airings, :content, :text
  end
end
