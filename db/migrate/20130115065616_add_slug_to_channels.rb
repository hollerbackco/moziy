class AddSlugToChannels < ActiveRecord::Migration
  def up
    add_column :channels, :slug, :string, default: "", null: false

    Channel.all.each do |c|
      title = c.title.parameterize("_")

      if Channel.find_by_slug title
        title = "#{title}#{Random.rand(11)}"
      end

      c.slug = title
      puts title
      puts c.save
      puts c.title
    end

    add_index :channels, :slug, unique: true
  end

  def down
    remove_column :channels, :slug
  end
end
