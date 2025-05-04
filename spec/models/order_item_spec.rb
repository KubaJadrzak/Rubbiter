require "rails_helper"

RSpec.describe OrderItem, type: :model do
  let(:order) { create(:order) }
  let(:product1) { create(:product, price: 25.0) }
  let(:product2) { create(:product, price: 25.0) }

  let(:order_item1) { create(:order_item, order: order, product: product1, quantity: 2, price_at_purchase: product1.price) }
  let(:order_item2) { create(:order_item, order: order, product: product2, quantity: 2, price_at_purchase: product2.price) }

  describe "#total_price" do
    it "calculates the total price correctly" do
      total_price = order_item1.total_price + order_item2.total_price
      expect(total_price).to eq(100)
    end
  end
end
