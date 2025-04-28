require "rails_helper"

RSpec.describe "EspagoBackRequests", type: :request do
  let(:order) { create(:order, payment_id: "pay_12345") }

  describe "Back request received with correct authorization" do
    states = {
      "executed" => { status: "Preparing for Shipment", payment_status: "Paid" },
      "rejected" => { status: "Payment Failed", payment_status: "Failed" },
      "failed" => { status: "Payment Failed", payment_status: "Failed" },
      "preauthorized" => { status: "Waiting for Payment", payment_status: "Pending" },
      "tds2_challenge" => { status: "Waiting for Payment", payment_status: "Pending" },
      "tds_redirected" => { status: "Waiting for Payment", payment_status: "Pending" },
      "dcc_decision" => { status: "Waiting for Payment", payment_status: "Pending" },
      "blik_redirected" => { status: "Waiting for Payment", payment_status: "Pending" },
      "transfer_redirected" => { status: "Waiting for Payment", payment_status: "Pending" },
      "resigned" => { status: "Payment Failed", payment_status: "Failed" },
      "reversed" => { status: "Payment Failed", payment_status: "Failed" },
      "refunded" => { status: "Payment Refunded", payment_status: "Refunded" },
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

  describe "Back request received with incorrect authorization" do
    it "returns a 401 Unauthorized" do
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
      expect(order.payment_status).not_to eq("Paid")
      expect(order.status).not_to eq("Preparing for Shipment")
    end
  end
end
