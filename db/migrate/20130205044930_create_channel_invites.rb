class CreateChannelInvites < ActiveRecord::Migration
  def change
    create_table :channel_invites do |t|
      t.integer :sender_id
      t.integer :channel_id
      t.string :recepient_email
      t.string :token
      t.datetime :sent_at

      t.timestamps
    end
  end
end
