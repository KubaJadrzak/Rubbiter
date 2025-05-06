require "rails_helper"

RSpec.describe PaymentsController, type: :request do
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user) }

  before do
    sign_in user
  end

  describe "POST #start_payment" do
    context "when correct auth data is used" do
      it "initializes Espago payment service, updates the order with payment_id, and receives redirect_url to Espago SWP" do
        get "/payments/start_payment/#{order.id}"
        order.reload
        expect(order.payment_id).to be_present
        expect(response).to redirect_to("https://sandbox.espago.com/secure_web_page/#{order.payment_id}")
      end
    end

    context "when incorrect auth data is used" do
      it "redirect to order show page, shows payment service error and failed payment status" do
        error_response = OpenStruct.new(success?: false, status: 401, body: { error: "Unauthorized" }.to_json)
        allow_any_instance_of(EspagoClientService).to receive(:send).and_return(error_response)
        get "/payments/start_payment/#{order.id}"
        order.reload
        expect(order.payment_id).to be_nil
        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include("Payment Failed")
        expect(response.body).to include("Failed")
        expect(response.body).to include("We are experiencing an issue with payment service")
      end
    end
  end

  describe "GET #payment_success" do
    context "when order is found" do
      it "redirects to order with success message" do
        get "/payments/payment_success", params: { order_number: order.order_number }

        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include("Payment successful!")
      end
    end

    context "when order is not found" do
      it "redirects to orders path with payment service issue message" do
        get "/payments/payment_success", params: { order_number: "INVALID123" }
        expect(response).to redirect_to(orders_path)
        follow_redirect!
        expect(response.body).to include("We are experiencing an issue with your order")
      end
    end
  end

  describe "GET #payment_failure" do
    context "when order is found" do
      it "redirects to order with failure message" do
        get "/payments/payment_failure", params: { order_number: order.order_number }
        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include("Payment failed!")
      end
    end

    context "when order is not found" do
      it "redirects to orders path with payment service issue message" do
        get "/payments/payment_failure", params: { order_number: "INVALID123" }
        expect(response).to redirect_to(orders_path)
        follow_redirect!
        expect(response.body).to include("We are experiencing an issue with your order")
      end
    end
  end
end
