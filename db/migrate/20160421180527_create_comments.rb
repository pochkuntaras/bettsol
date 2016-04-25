class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.references :commentable, polymorphic: true, index: true, null: false
      t.text :content, null: false
      t.timestamps null: false
    end
  end
end
