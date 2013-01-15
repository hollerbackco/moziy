class AddSlugToChannels < ActiveRecord::Migration
  def up
    add_column :channels, :slug, :string, default: "", null: false

    Channel.all.each do |c|
      title = c.title.parameterize

      if Channel.find_by_slug title
        title = title + title
      end
      c.slug = title
      c.save
    end

    add_index :channels, :slug, unique: true
  end

  def down
    remove_column :channels, :slug
  end
end
