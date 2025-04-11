# content: string

class Rubit < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  
  # A rubit can have many child rubits (comments)
  has_many :child_rubits, class_name: 'Rubit', foreign_key: 'parent_rubit_id', dependent: :destroy
  
  # A rubit can belong to a parent rubit (if it's a comment)
  belongs_to :parent_rubit, class_name: 'Rubit', optional: true

  validates :content, presence: true, length: { maximum: 204 }
end
