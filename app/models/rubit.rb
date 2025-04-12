class Rubit < ApplicationRecord
  belongs_to :user
  belongs_to :parent_rubit, class_name: 'Rubit', optional: true
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :child_rubits, class_name: 'Rubit', foreign_key: 'parent_rubit_id', dependent: :destroy
  has_many :hashtaggings
  has_many :hashtags, through: :hashtaggings


  enum :status, { active: 0, removed: 1 }
  
  validates :content, presence: true, length: { maximum: 204 }

  after_save :create_hashtags


  scope :active, -> { where(status: 'active') }

  # Scope to find root rubits
  def self.find_root_rubits
    where(parent_rubit_id: nil)
  end

  def create_hashtags
    # Extract hashtags from the rubit content
    hashtags_in_content = content.scan(/#\w+/).map { |hashtag| hashtag.downcase.delete("#") }

    hashtags_in_content.each do |hashtag_name|
      hashtag = Hashtag.find_or_create_by(name: hashtag_name)
      self.hashtags << hashtag unless self.hashtags.include?(hashtag)
    end
  end

  def extract_hashtags
    hashtag_names = content.scan(/#\w+/).uniq # Extract hashtags
    self.hashtags = hashtag_names.map { |name| Hashtag.find_or_create_by(name: name.downcase) }
  end

  # Method to check if a rubit is a child rubit (i.e., has a parent)
  def is_child_rubit?
    parent_rubit_id.present?
  end
end
