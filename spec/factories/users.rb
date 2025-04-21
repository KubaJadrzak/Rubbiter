FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { Faker::Internet.email }   # Generates a random email
    password { "password123" }        # Sets the password (Devise requires this)
    password_confirmation { password } # Devise requires password_confirmation to match
  end
end
