class RemoveColumnPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :title
    remove_column :posts, :body
  end
end
