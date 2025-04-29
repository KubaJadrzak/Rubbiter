FactoryBot.define do
  factory :order do
    association :user
    shipping_address { "Poland, Main Street 123, 00-000" }
    status { "Created" }
    payment_status { "Initialized" }
    ordered_at { Time.current }
    payment_id { nil }
    total_price { 0 }

    trait :without_items do
      after(:create) do |order|
        order.calculate_total_price
        order.save!
      end
    end

    trait :with_items do
      after(:create) do |order|
        product1 = create(:product, price: 10)
        product2 = create(:product, price: 20)
        create(:order_item, order: order, product: product1, quantity: 2, price_at_purchase: product1.price)
        create(:order_item, order: order, product: product2, quantity: 1, price_at_purchase: product2.price)

        order.calculate_total_price
        order.save!
      end
    end
  end
end
