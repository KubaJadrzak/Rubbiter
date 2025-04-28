# spec/requests/payments_spec.rb

require "rails_helper"

RSpec.describe "Payments", type: :request do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }

  before do
    sign_in user
    # Assume cart has some items
    create(:cart_item, cart: cart)
  end

  describe "POST /orders" do
    it "creates an order and redirects to start payment" do
      post orders_path, params: {
                     order: {
                       country: "Poland",
                       street: "Main Street 1",
                       postal_code: "00-001",
                     },
                   }

      expect(response).to redirect_to(start_payment_path(order_id: Order.last.id))
      expect(Order.last.status).to eq("created")
      expect(Order.last.payment_status).to eq("pending")
    end
  end

  describe "GET /start_payment" do
    it "registers a payment and redirects to espago URL" do
      order = create(:order, user: user, total_price: 100, status: "created", payment_status: "pending")

      # Mock EspagoPaymentService to avoid real HTTP call
      fake_response = instance_double(Net::HTTPSuccess, body: { id: "pay_fakeid", redirect_url: "https://fake-espago.com/pay" }.to_json)
      allow_any_instance_of(EspagoPaymentService).to receive(:create_payment).and_return(fake_response)

      get start_payment_path(order_id: order.id)

      expect(response).to redirect_to("https://fake-espago.com/pay")
      order.reload
      expect(order.payment_id).to eq("pay_fakeid")
    end
  end
end
