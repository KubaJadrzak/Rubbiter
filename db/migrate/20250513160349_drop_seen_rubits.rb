class DropSeenRubits < ActiveRecord::Migration[8.0]
  def up
    drop_table :seen_rubits
  end

  def down
    create_table :seen_rubits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :rubit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
