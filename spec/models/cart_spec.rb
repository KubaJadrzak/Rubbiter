require "rails_helper"

RSpec.describe Cart, type: :model do
  let(:user) { create(:user) }
  let(:product1) { create(:product, price: 30.0) }
  let(:product2) { create(:product, price: 10.0) }
  let!(:cart_item1) { create(:cart_item, cart: user.cart, product: product1, quantity: 2, price: product1.price) }
  let!(:cart_item2) { create(:cart_item, cart: user.cart, product: product2, quantity: 3, price: product2.price) }
  describe "#total_price" do
    it "calculat correctly total price of all cart items" do
      total_price = user.cart.total_price
      expect(total_price).to eq(90)
    end
  end
end
