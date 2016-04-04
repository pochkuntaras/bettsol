class AddBestToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :best, :boolean, null: false, default: false
    add_index :answers, :best
  end
end
