class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :channel_id
      t.integer :owner_id
      
      t.integer :airings_count
      
      t.string :title
      t.text :body
      t.text :description

      t.timestamps
    end
  end
end
