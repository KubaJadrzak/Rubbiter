FactoryBot.define do
  factory :order do
    association :user
    shipping_address { "Poland, Main Street 123, 00-000" }
    status { "Created" }
    payment_status { "Initialized" }
    ordered_at { Time.current }
    order_number { SecureRandom.hex(10) }
    payment_id { nil }

    total_price { order_items.sum(&:price_at_purchase) }

    after(:create) do |order|
      create_list(:order_item, 3, order: order)

      order.update(total_price: order.order_items.sum(&:price_at_purchase))
    end
  end
end
