class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :comment, null: false
      t.references :post, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :comments, [:post_id, :user_id]
  end
end
