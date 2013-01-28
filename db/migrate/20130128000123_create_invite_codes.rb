class CreateInviteCodes < ActiveRecord::Migration
  def change
    create_table :invite_codes do |t|
      t.integer :user_id
      t.string :state
      t.string :code

      t.timestamps
    end
    add_index :invite_codes, :code, unique: true
  end
end
