class SeenRubit < ApplicationRecord
  belongs_to :user
  belongs_to :rubit

  validates :rubit_id, uniqueness: { scope: :user_id }
end
