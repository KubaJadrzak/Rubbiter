class AddStatusToRubits < ActiveRecord::Migration[8.0]
  def change
    add_column :rubits, :status, :integer, default: 0
  end
end
