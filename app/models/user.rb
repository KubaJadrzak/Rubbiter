class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :rubits, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_rubits, through: :likes, source: :rubit
  has_many :seen_rubits, dependent: :destroy
  has_many :seen_rubits_list, through: :seen_rubits, source: :rubit
  validates :username, presence: true, uniqueness: true

  def root_rubits
    rubits.where(parent_rubit_id: nil)
  end

  def comments
    rubits.where.not(parent_rubit_id: nil)
  end

  def total_likes
    rubits.joins(:likes).count
  end

  def self.trending_users
    joins(rubits: :likes)
      .group("users.id")
      .order("COUNT(likes.id) DESC")
      .limit(5)
  end
end
