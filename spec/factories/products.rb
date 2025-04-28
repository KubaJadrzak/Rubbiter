FactoryBot.define do
  factory :product do
    title { Faker::Commerce.product_name }
    content { Faker::Lorem.sentence(word_count: 15) }
    price { Faker::Commerce.price(range: 5..50.0) }
  end
end
