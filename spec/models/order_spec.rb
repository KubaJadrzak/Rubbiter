require "rails_helper"

RSpec.describe Order, type: :model do
  # Associations
  it { should belong_to(:user) }
  it { should have_many(:order_items).dependent(:destroy) }

  # Validations
  it { should validate_presence_of(:total_price) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:ordered_at) }

  # Instance methods
  describe "#calculate_total_price" do
    let(:user) { create(:user) }
    let(:order) { create(:order, :with_items, user: user) }

    it "calculates the correct total price based on order items" do
      expect(order.total_price).to eq(40)
    end
  end

  describe "#build_order_items_from_cart" do
    let(:user) { create(:user) }
    let(:order) { create(:order, :without_items, user: user) }

    it "builds order items from the cart" do
      cart_item = create(:cart_item, cart: user.cart)

      order.build_order_items_from_cart(user.cart)
      order.save!

      expect(order.order_items.count).to eq(1)

      expect(order.order_items.first.product).to eq(cart_item.product)
      expect(order.order_items.first.quantity).to eq(cart_item.quantity)
      expect(order.order_items.first.price_at_purchase).to eq(cart_item.price)
    end
  end

  describe "callbacks" do
    it "generates an order number before creation" do
      order = build(:order)
      expect(order.order_number).to be_nil
      order.save
      expect(order.order_number).to_not be_nil
    end
  end
end
