class AllowNullUserIdInOrders < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :orders, :users
    add_foreign_key :orders, :users, on_delete: :nullify
    change_column_null :orders, :user_id, true
  end
end
