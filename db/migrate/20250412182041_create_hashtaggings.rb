class CreateHashtaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :hashtaggings do |t|
      t.references :rubit, null: false, foreign_key: true  # Links to rubit
      t.references :hashtag, null: false, foreign_key: true  # Links to hashtag

      t.timestamps
    end

    # Ensures that a rubit can't have the same hashtag twice (optional but recommended)
    add_index :hashtaggings, [:rubit_id, :hashtag_id], unique: true
  end
end
