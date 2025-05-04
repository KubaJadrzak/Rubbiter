FactoryBot.define do
  factory :rubit do
    content { "This is an example Rubit #example" }
    association :user
  end
end
