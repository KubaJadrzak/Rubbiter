class User < ApplicationRecord
    has_many :rubits,  dependent: :destroy

    validates :username, presence: true, uniqueness: true
end
