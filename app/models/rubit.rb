class Rubit < ApplicationRecord
  belongs_to :user
  belongs_to :parent_rubit, class_name: 'Rubit', optional: true
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user
  has_many :child_rubits, class_name: 'Rubit', foreign_key: 'parent_rubit_id', dependent: :destroy
  has_many :hashtaggings, dependent: :destroy 
  has_many :hashtags, through: :hashtaggings

  validates :content, presence: true, length: { maximum: 204 }

  after_save :create_hashtags

  scope :ordered_by_likes, -> {
    left_joins(:likes)
    .group('rubits.id')
    .order('COUNT(likes.id) DESC')
    .where('likes.created_at >= ?', 24.hours.ago).or(where(likes: { id: nil }))
  }
  
  def self.find_root_rubits
    where(parent_rubit_id: nil)
  end

  def create_hashtags
    hashtags_in_content = content.scan(/#\w+/).map { |hashtag| hashtag.downcase.delete("#") }

    hashtags_in_content.each do |hashtag_name|
      hashtag = Hashtag.find_or_create_by(name: hashtag_name)
      self.hashtags << hashtag unless self.hashtags.include?(hashtag)
    end
  end

  def likes_in_last_24_hours
    likes.where('likes.created_at >= ?', 24.hours.ago).count
  end

  def extract_hashtags
    hashtag_names = content.scan(/#\w+/).uniq
    self.hashtags = hashtag_names.map { |name| Hashtag.find_or_create_by(name: name.downcase) }
  end

  def is_child_rubit?
    parent_rubit_id.present?
  end
end
