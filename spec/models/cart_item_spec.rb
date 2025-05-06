require "rails_helper"

RSpec.describe CartItem, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:product, price: 30.0) }
  let(:cart_item) { create(:cart_item, cart: user.cart, product: product, quantity: 2, price: product.price) }
  describe "#total_price" do
    it "calculat correctly total price of a specific cart item" do
      total_price = cart_item.total_price()
      expect(total_price).to eq(60)
    end
  end
end
