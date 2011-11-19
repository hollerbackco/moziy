class AddCoverArtToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :cover_art, :string
    add_column :channels, :random_string, :string
  end
end
