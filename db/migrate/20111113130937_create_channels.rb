class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.integer :creator_id
      
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
