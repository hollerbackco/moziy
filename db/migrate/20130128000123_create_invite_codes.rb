class CreateInviteCodes < ActiveRecord::Migration
  def change
    create_table :invite_codes do |t|
      t.string :code
      t.integer :user_id

      t.timestamps
    end
    add_index :invite_codes, :code, unique: true
  end
end
