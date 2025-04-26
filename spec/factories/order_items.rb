FactoryBot.define do
  factory :order_item do
    order { nil }
    product { nil }
    quantity { 1 }
    price_at_purchase { "9.99" }
  end
end
