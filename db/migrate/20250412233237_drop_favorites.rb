class DropFavorites < ActiveRecord::Migration[8.0]
  def change
    drop_table :favorites
  end
end
