FactoryBot.define do
  factory :order do
    user { nil }
    total_price { "9.99" }
    status { "MyString" }
    payment_status { "MyString" }
    shipping_address { "MyText" }
    ordered_at { "2025-04-26 13:41:18" }
  end
end
