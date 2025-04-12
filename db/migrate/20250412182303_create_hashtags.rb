class CreateHashtags < ActiveRecord::Migration[6.0]
  def change
    create_table :hashtags do |t|
      t.string :name, null: false, unique: true  # We ensure hashtags are unique
      t.timestamps
    end

    add_index :hashtags, :name, unique: true  # Add index for efficient querying
  end
end