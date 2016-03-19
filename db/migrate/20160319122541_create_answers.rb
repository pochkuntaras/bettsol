class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :question, index: true, foreign_key: true, null: false
      t.text :content, null: false
      t.timestamps null: false
    end
  end
end
