require "rails_helper"

RSpec.describe PaymentsController, type: :request do
  describe "POST #start_payment" do
    let!(:order) { create(:order, :with_items) }

    context "when payment is successful" do
      let(:espago_response) {
        OpenStruct.new(
          success?: true,
          body: {
            id: "payment123",
            redirect_url: "https://espago.com/redirect",
          }.to_json,
        )
      }

      before do
        allow_any_instance_of(EspagoPaymentService).to receive(:create_payment).and_return(espago_response)
      end

      it "updates the order with payment_id" do
        post "/payments/start_payment", params: { order_id: order.id }
        expect(order.reload.payment_id).to eq("payment123")
      end

      it "redirects to the Espago redirect URL" do
        post "/payments/start_payment", params: { order_id: order.id }
        expect(response).to redirect_to("https://espago.com/redirect")
      end
    end

    context "when payment fails" do
      let(:espago_response) {
        OpenStruct.new(
          success?: false,
          body: { id: nil, error: "something went wrong" }.to_json,
        )
      }

      before do
        allow_any_instance_of(EspagoPaymentService).to receive(:create_payment).and_return(espago_response)
      end

      it "updates the order with failure status" do
        post "/payments/start_payment", params: { order_id: order.id }
        expect(order.reload.payment_status).to eq("connection failed")
        expect(order.reload.status).to eq("Payment Failed")
      end

      it "redirects back to the order page with alert" do
        post "/payments/start_payment", params: { order_id: order.id }
        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include("We are experiencing an issue with payment service")
      end
    end
  end

  describe "GET #payment_success" do
    context "when order is found" do
      let!(:order) { create(:order, :with_items) }

      it "redirects to order with success message" do
        get "/payments/payment_success", params: { order_number: order.order_number }
        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include("Payment successful!")
      end
    end

    context "when order is not found" do
      it "redirects to orders with alert" do
        get "/payments/payment_success", params: { order_number: "INVALID123" }
        expect(response).to redirect_to(orders_path)
        follow_redirect!
        expect(response.body).to include("We are experiencing an issue with your order")
      end
    end
  end

  describe "GET #payment_failure" do
    context "when order is found" do
      let!(:order) { create(:order, :with_items) }

      it "redirects to order with failure message" do
        get "/payments/payment_failure", params: { order_number: order.order_number }
        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include("Payment failed!")
      end
    end

    context "when order is not found" do
      it "redirects to orders with alert" do
        get "/payments/payment_failure", params: { order_number: "INVALID123" }
        expect(response).to redirect_to(orders_path)
        follow_redirect!
        expect(response.body).to include("We are experiencing an issue with your order")
      end
    end
  end
end
