class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.text :content
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
