class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :rubits, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_rubits, through: :likes, source: :rubit
  validates :username, presence: true, uniqueness: true


  def root_rubits
    rubits.where(parent_rubit_id: nil)
  end

  def comments
    rubits.where.not(parent_rubit_id: nil)
  end

  def total_likes
    rubits.joins(:likes).where('likes.created_at >= ?', 24.hours.ago).count
  end

  def self.trending_users
    joins(rubits: :likes)  # Join users, rubits, and likes tables
      .where('likes.created_at >= ?', 24.hours.ago)  # Filter likes within the past 24 hours
      .group('users.id')  # Group by user
      .order('COUNT(likes.id) DESC')  # Order by the number of likes (descending)
      .limit(5)  # Limit to top 5 trending users
  end
end
