class AddColumnToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :caption, :text, null: false
    add_column :posts, :weather, :string, null: false
    add_column :posts, :feeling, :string, null: false
    add_column :posts, :expectation, :string, null: false
  end
end
