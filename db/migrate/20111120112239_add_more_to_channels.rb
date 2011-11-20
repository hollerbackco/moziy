class AddMoreToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :type, :string
    add_column :channels, :private, :boolean
    add_column :channels, :score, :integer
  end
end
