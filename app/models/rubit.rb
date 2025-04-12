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

  enum :status, { active: 0, removed: 1 }
  
  validates :content, presence: true, length: { maximum: 204 }

  # Scope to find root rubits
  def self.find_root_rubits
    where(parent_rubit_id: nil)
  end

  # Method to check if a rubit is a child rubit (i.e., has a parent)
  def is_child_rubit?
    parent_rubit_id.present?
  end
end
