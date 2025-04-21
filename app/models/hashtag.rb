class Hashtag < ApplicationRecord
  has_many :hashtaggings
  has_many :rubits, through: :hashtaggings

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def count_likes
    rubits.joins(:likes).count
  end

  scope :trending, -> {
          joins(:hashtaggings)
            .joins("INNER JOIN rubits ON rubits.id = hashtaggings.rubit_id")
            .joins("INNER JOIN likes ON likes.rubit_id = rubits.id")
            .group("hashtags.id")
            .order("COUNT(likes.id) DESC")
            .limit(10)
        }
end
