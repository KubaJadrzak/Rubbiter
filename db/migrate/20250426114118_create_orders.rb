class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price
      t.string :status
      t.string :payment_status
      t.text :shipping_address
      t.datetime :ordered_at

      t.timestamps
    end
  end
end
