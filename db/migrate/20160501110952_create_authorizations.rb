class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string  :confirmation_token, null: false
      t.datetime :confirmed_at
      t.timestamps null: false
    end

    add_index :authorizations, [:provider, :uid], unique: true
  end
end
