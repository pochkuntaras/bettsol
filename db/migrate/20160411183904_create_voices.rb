class CreateVoices < ActiveRecord::Migration
  def change
    create_table :voices do |t|
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.references :votable, polymorphic: true, index: true
      t.integer :solution, null: false
      t.timestamps null: false
    end
  end
end
