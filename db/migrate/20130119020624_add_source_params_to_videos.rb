class AddSourceParamsToVideos < ActiveRecord::Migration
  def up
    add_column :videos, :video_image, :string
    add_column :videos, :random_string, :string
    add_column :videos, :source_meta, :text

    remove_column :videos, "source_author_name"
    remove_column :videos, "provider_object_id"
    remove_column :videos, "provider_user_name"
    remove_column :videos, "provider_user_image"
    remove_column :videos, "provider_user_nick"
    remove_column :videos, "provider_user_id"
    remove_column :videos, "provider_thumbnail_url"
    remove_column :videos, "provider_thumbnail_width"
    remove_column :videos, "provider_thumbnail_height"
  end

  def down
    remove_column :videos, :video_image
    remove_column :videos, :random_string
    remove_column :videos, :source_meta

    add_column :videos, "source_author_name", :string
    add_column :videos, "provider_object_id", :string
    add_column :videos, "provider_user_name", :string
    add_column :videos, "provider_user_image", :string
    add_column :videos, "provider_user_nick", :string
    add_column :videos, "provider_user_id", :string
    add_column :videos, "provider_thumbnail_url", :string
    add_column :videos, "provider_thumbnail_width", :integer
    add_column :videos, "provider_thumbnail_height", :integer
  end
end
