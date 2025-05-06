require "rails_helper"

RSpec.describe OrderItem, type: :model do
  let(:order) { create(:order) }
  let(:product) { create(:product, price: 25.0) }
  let(:order_item) { create(:order_item, order: order, product: product, quantity: 2, price_at_purchase: product.price) }

  describe "#total_price" do
    it "calculates the total price of order item correctly" do
      total_price = order_item.total_price
      expect(total_price).to eq(50)
    end
  end
end
