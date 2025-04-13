class RemoveStatusFromRubits < ActiveRecord::Migration[8.0]
  def change
    remove_column :rubits, :status, :integer
  end
end
