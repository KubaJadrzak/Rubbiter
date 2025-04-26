class AddOrderNumberToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :order_number, :string, null: false
    add_index :orders, :order_number, unique: true
  end
end
