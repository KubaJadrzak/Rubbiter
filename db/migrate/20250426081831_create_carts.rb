class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :user, foreign_key: true, null: true  # allow guest carts
      t.timestamps
    end
  end
end
