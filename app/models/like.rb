class Like < ApplicationRecord
  belongs_to :user
  belongs_to :rubit

  validates :user_id, uniqueness: { scope: :rubit_id }
end
