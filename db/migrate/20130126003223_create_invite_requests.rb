class CreateInviteRequests < ActiveRecord::Migration
  def change
    create_table :invite_requests do |t|
      t.string :email
      t.string :state

      t.timestamps
    end

    add_index :invite_requests, :email, :unique => true
  end
end
