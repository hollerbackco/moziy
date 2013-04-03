class CreateAuthorizations < ActiveRecord::Migration
  def up
    create_table :authorizations do |t|
      t.string  :provider
      t.string  :uid
      t.integer :user_id
      t.string  :access_token
      t.datetime  :expires_at
      t.text    :meta

      t.timestamps
    end

    if ActiveRecord::Base.connection.tables.include?(:authentications)
      drop_table :authentications
    end

    add_index :authorizations, :user_id
  end

  def down
    drop_table :authorizations
  end
end


