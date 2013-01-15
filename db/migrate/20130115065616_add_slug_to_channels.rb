class AddSlugToChannels < ActiveRecord::Migration
  def up
    add_column :channels, :slug, :string, default: "", null: false

    Channel.all.each do |c|
      c.slug = c.title.parameterize
      c.save
    end

    add_index :channels, :slug, unique: true
  end

  def down
    remove_column :channels, :slug
  end
end
