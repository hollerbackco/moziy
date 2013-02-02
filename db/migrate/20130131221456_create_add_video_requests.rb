class CreateAddVideoRequests < ActiveRecord::Migration
  def change
    create_table :add_video_requests do |t|
      t.integer :channel_id
      t.string :urls
      t.string :state
      t.text :msg

      t.timestamps
    end
  end
end
