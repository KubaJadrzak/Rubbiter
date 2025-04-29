FactoryBot.define do
  factory :rubit do
    content do
      sentence = Faker::Lorem.sentence(word_count: 9)
      sentence + " ##{Faker::Lorem.word}"
    end
    association :user
  end
end
