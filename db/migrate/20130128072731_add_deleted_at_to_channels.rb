class AddDeletedAtToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :deleted_at, :datetime
  end
end
