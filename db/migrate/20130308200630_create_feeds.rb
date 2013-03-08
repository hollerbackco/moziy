class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :feed_type
      t.string :slug
      t.string :source_url
      t.string :source_name

      t.timestamps
    end
    add_index :feeds, :feed_type
    add_index :feeds, :slug
  end
end
