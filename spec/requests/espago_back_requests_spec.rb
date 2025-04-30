require "rails_helper"

RSpec.describe "EspagoBackRequests", type: :request do
  let(:order) { create(:order, :with_items, payment_id: "pay_12345") }

  describe "POST /back_request with correct authorization" do
    states = {
      "executed" => { status: "Preparing for Shipment", payment_status: "executed" },
      "rejected" => { status: "Payment Failed", payment_status: "rejected" },
      "failed" => { status: "Payment Failed", payment_status: "failed" },
      "preauthorized" => { status: "Waiting for Payment", payment_status: "preauthorized" },
      "tds2_challenge" => { status: "Waiting for Payment", payment_status: "tds2_challenge" },
      "tds_redirected" => { status: "Waiting for Payment", payment_status: "tds_redirected" },
      "dcc_decision" => { status: "Waiting for Payment", payment_status: "dcc_decision" },
      "blik_redirected" => { status: "Waiting for Payment", payment_status: "blik_redirected" },
      "transfer_redirected" => { status: "Waiting for Payment", payment_status: "transfer_redirected" },
      "resigned" => { status: "Payment Failed", payment_status: "resigned" },
      "reversed" => { status: "Payment Failed", payment_status: "reversed" },
      "refunded" => { status: "Payment Refunded", payment_status: "refunded" },
      "new" => { status: "Waiting for Payment", payment_status: "new" },
    }

    states.each do |state, expected_values|
      it "updates the order correctly for state '#{state}' with payment_status '#{expected_values[:payment_status]}' and status '#{expected_values[:status]}'" do
        valid_payload = {
          "id" => "pay_12345",
          "state" => state,
        }

        headers = {
          "Authorization" => "Basic #{Base64.strict_encode64("#{Rails.application.credentials.dig(:espago, :app_id)}:#{Rails.application.credentials.dig(:espago, :password)}")}",
          "Content-Type" => "application/json",
        }

        allow(Order).to receive(:find_by).with(payment_id: "pay_12345").and_return(order)

        post "/back_request", params: valid_payload.to_json, headers: headers

        order.reload

        expect(order.payment_status).to eq(expected_values[:payment_status])
        expect(order.status).to eq(expected_values[:status])

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /back_request with invalid authorization" do
    it "returns a 401 Unauthorized and doesn't update order status and payment status" do
      order.update(payment_id: "pay_12345")

      valid_payload = {
        "id" => "pay_12345",
        "state" => "executed",
      }

      incorrect_headers = {
        "Authorization" => "Basic #{Base64.strict_encode64("incorrect_user:incorrect_password")}",
        "Content-Type" => "application/json",
      }

      allow(Order).to receive(:find_by).with(payment_id: "pay_12345").and_return(order)

      post "/back_request", params: valid_payload.to_json, headers: incorrect_headers

      expect(response).to have_http_status(:unauthorized)

      order.reload
      expect(order.payment_status).not_to eq("executed")
      expect(order.status).not_to eq("Preparing for Shipment")
    end
  end
end
