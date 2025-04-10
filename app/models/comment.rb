class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :rubit
end
