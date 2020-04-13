class AddGuestToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :guest, :boolean, default: false
  end
end
