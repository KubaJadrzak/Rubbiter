# content: string

class Rubit < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 204 }
end
