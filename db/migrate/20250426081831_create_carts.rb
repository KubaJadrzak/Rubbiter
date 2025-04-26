class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :user, foreign_key: true, null: true  # allow guest carts if you want
      t.timestamps
    end
  end
end
