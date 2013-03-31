class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string  :provider
      t.string  :uid
      t.integer :user_id
      t.string  :access_token
      t.text    :meta

      t.timestamps
    end

    add_index :authorizations, :user_id

    drop_table :authentications
  end
end
