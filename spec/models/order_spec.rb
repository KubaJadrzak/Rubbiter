require "rails_helper"

RSpec.describe Order, type: :model do
  describe "validations" do
    let(:user) { create(:user) }

    it "does not allow an order to be created without order items" do
      order = build(:order, user: user)
      order.order_items = []
      order.valid?

      expect(order.errors[:order_items]).to include("must have at least one item.")
    end
  end
  describe "#build_order_items_from_cart" do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user) }

    it "builds order items from the cart" do
      cart_item = create(:cart_item, cart: user.cart)

      order.build_order_items_from_cart(user.cart)
      order.save!

      expect(order.order_items.count).to eq(3)

      expect(order.order_items.last.product).to eq(cart_item.product)
      expect(order.order_items.last.quantity).to eq(cart_item.quantity)
      expect(order.order_items.last.price_at_purchase).to eq(cart_item.price)
    end
  end

  describe "#user_facing_payment_status" do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user) }

    context "when payment status is 'executed'" do
      it "returns 'Paid'" do
        order.payment_status = "executed"
        expect(order.user_facing_payment_status).to eq("Paid")
      end
    end

    context "when payment status is 'rejected', 'failed', or 'connection failed'" do
      it "returns 'Failed'" do
        order.payment_status = "rejected"
        expect(order.user_facing_payment_status).to eq("Failed")

        order.payment_status = "failed"
        expect(order.user_facing_payment_status).to eq("Failed")

        order.payment_status = "connection failed"
        expect(order.user_facing_payment_status).to eq("Failed")
      end
    end

    context "when payment status is 'resigned'" do
      it "returns 'Resigned'" do
        order.payment_status = "resigned"
        expect(order.user_facing_payment_status).to eq("Resigned")
      end
    end

    context "when payment status is 'reversed'" do
      it "returns 'Reversed'" do
        order.payment_status = "reversed"
        expect(order.user_facing_payment_status).to eq("Reversed")
      end
    end

    context "when payment status is one of 'preauthorized', 'tds2_challenge', 'tds_redirected', 'dcc_decision', 'blik_redirected', 'transfer_redirected', 'new'" do
      it "returns 'Awaiting Confirmation'" do
        statuses = ["preauthorized", "tds2_challenge", "tds_redirected", "dcc_decision", "blik_redirected", "transfer_redirected", "new"]
        statuses.each do |status|
          order.payment_status = status
          expect(order.user_facing_payment_status).to eq("Awaiting Confirmation")
        end
      end
    end

    context "when payment status is 'refunded'" do
      it "returns 'Refunded'" do
        order.payment_status = "refunded"
        expect(order.user_facing_payment_status).to eq("Refunded")
      end
    end

    context "when payment status is 'Processing'" do
      it "returns 'Processing'" do
        order.payment_status = "Processing"
        expect(order.user_facing_payment_status).to eq("Processing")
      end
    end

    context "when payment status is unknown" do
      it "returns 'Unknown'" do
        order.payment_status = "unknown_status"
        expect(order.user_facing_payment_status).to eq("Unkown")
      end
    end
  end

  describe "callbacks" do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user) }
    it "generates an order number before creation" do
      expect(order.order_number).to_not be_nil
    end
  end
end
