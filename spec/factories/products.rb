FactoryBot.define do
  factory :product do
    title { "Sample Product" }
    content { "This is a detailed description of the product." }
    price { 25.0 }
  end
end
