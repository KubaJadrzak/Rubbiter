class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :rubits, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_rubits, through: :likes, source: :rubit
  has_many :favorites, dependent: :destroy
  has_many :favorite_rubits, through: :favorites, source: :rubit

  validates :username, presence: true, uniqueness: true


  def root_rubits
    rubits.where(parent_rubit_id: nil)
  end

  def comments
    rubits.where.not(parent_rubit_id: nil)
  end
end
