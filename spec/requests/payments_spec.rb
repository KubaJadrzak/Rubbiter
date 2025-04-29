require "rails_helper"

RSpec.describe "Payments", type: :request do
  describe "GET /payments/start_payment/:order_id" do
    let(:order) { create(:order, :with_items) }
    let(:espago_response_body_success) do
      {
        "id" => "pay_id",
        "redirect_url" => "https://sandbox.espago.com/secure_web_page/test",
      }.to_json
    end
    let(:success_response) do
      instance_double(Net::HTTPSuccess, body: espago_response_body_success, is_a?: true)
    end
    let(:failure_response) do
      double("failure_response", body: "Error message", is_a?: false)
    end

    context "when the payment service is successful" do
      before do
        allow(EspagoPaymentService).to receive(:new)
                                         .with(instance_of(Order))
                                         .and_return(double(create_payment: success_response))
      end

      it "redirects to Espago redirect_url and assigns payment_id to the order" do
        get start_payment_path(order_id: order.id)

        expect(response).to redirect_to("https://sandbox.espago.com/secure_web_page/test")

        order.reload
        expect(order.payment_id).to eq("pay_id")
      end
    end

    context "when the payment service fails" do
      before do
        allow(EspagoPaymentService).to receive(:new)
                                         .with(instance_of(Order))
                                         .and_return(double(create_payment: failure_response))
      end

      it "redirects to root_path with an error alert and updates the order's payment_status and status to failure" do
        get start_payment_path(order_id: order.id)

        expect(response).to redirect_to(order_path(order))
        follow_redirect!

        expect(flash[:alert]).to eq("Payment failed. Please try again.")

        order.reload
        expect(order.payment_status).to eq("Failed")
        expect(order.status).to eq("Payment Failed")
      end
    end
  end
  describe "GET /payments/payment_success" do
    let(:order) { create(:order, order_number: "123ABC") }

    it "updates the order status and redirects with notice" do
      get payment_success_path(order_number: order.order_number)

      expect(response).to redirect_to(order_path(order))
      follow_redirect!

      expect(flash[:notice]).to eq("Payment successful!")
      order.reload
      expect(order.payment_status).to eq("Paid")
      expect(order.status).to eq("Preparing for Shipment")
    end
  end
  describe "GET /payments/payment_failure" do
    let(:order) { create(:order, order_number: "123ABC") }

    it "updates the order status and redirects with alert" do
      get payment_failure_path(order_number: order.order_number)

      expect(response).to redirect_to(order_path(order))
      follow_redirect!

      expect(flash[:alert]).to eq("Payment failed. Please try again.")
      order.reload
      expect(order.payment_status).to eq("Failed")
      expect(order.status).to eq("Payment Failed")
    end
  end
end
