class AddMoreToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :source_author_name, :string
    add_column :videos, :provider_object_id, :string
    add_column :videos, :provider_user_name, :string
    add_column :videos, :provider_user_image, :string
    add_column :videos, :provider_user_nick, :string
    add_column :videos, :provider_user_id, :string
    add_column :videos, :provider_thumbnail_url, :string
    add_column :videos, :provider_thumbnail_width, :integer
    add_column :videos, :provider_thumbnail_height, :integer
  end
end
