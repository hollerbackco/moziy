class CreateAirings < ActiveRecord::Migration
  def change
    create_table :airings do |t|
      t.integer :video_id
      t.integer :channel_id

      t.timestamps
    end
  end
end
