class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.references :prefecture, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
