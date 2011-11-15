class AddSourceToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :source_name, :string
    add_column :videos, :source_id, :string
  end
end
