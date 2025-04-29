require "rails_helper"

RSpec.describe "Payment Flow", type: :system do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, :with_items, user: user, items_count: 2) }

  def start_checkout_flow
    login_as(user, scope: :user)
    visit cart_path(cart)

    expect(page).to have_content("Your Cart")
    expect(page).to have_selector(".cart-item", count: 2)

    click_link "Place Order"
    expect(current_path).to eq(new_order_path)

    fill_in "Country", with: "France"
    fill_in "Street Address", with: "123 Rails Ave"
    fill_in "Postal Code", with: "75001"

    click_button "Purchase"
    expect(current_url).to match(/secure_web_page/)

    order = Order.last
    expect(page).to have_content(order.order_number)
    expect(page).to have_content(order.total_price.to_s)

    order
  end

  context "when payment is successful" do
    it "updates order status to Preparing for Shipment and payment status to Paid" do
      order = start_checkout_flow

      visit payment_success_path(order_number: order.order_number)

      order.reload
      expect(order.payment_status).to eq("Paid")
      expect(order.status).to eq("Preparing for Shipment")

      expect(current_path).to eq(order_path(order))
      expect(page).to have_content("Payment successful!")
    end
  end

  context "when payment fails" do
    it "updates order status to Payment Failed and payment status to Failed" do
      order = start_checkout_flow

      visit payment_failure_path(order_number: order.order_number)

      order.reload
      expect(order.payment_status).to eq("Failed")
      expect(order.status).to eq("Payment Failed")

      expect(current_path).to eq(order_path(order))
      expect(page).to have_content("Payment failed. Please try again.")
    end
  end

  context "when payment is abandoned" do
    it "sets payment status to Processing... and order status to Created" do
      order = start_checkout_flow

      visit order_path(order)  # simulate user skipping payment

      order.reload
      expect(order.payment_status).to eq("Processing...")
      expect(order.status).to eq("Created")
    end
  end
end
