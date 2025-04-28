class EspagoBackRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:handle_back_request]
  before_action :authenticate_espago!

  def handle_back_request
    payload = JSON.parse(request.body.read)

    payment_id = payload["id"]
    order = Order.find_by(payment_id: payment_id)

    if order
      case payload["state"]
      when "executed"
        order.update(payment_status: "Paid", status: "Preparing for Shipment")
      when "rejected", "failed", "resigned", "reversed"
        order.update(payment_status: "Failed", status: "Payment Failed")
      when "preauthorized", "tds2_challenge", "tds_redirected", "dcc_decision", "blik_redirected", "transfer_redirected"
        order.update(payment_status: "Pending", status: "Waiting for Payment")
      when "refunded"
        order.update(payment_status: "Refunded", status: "Payment Refunded")
      else
        # Handle unknown states if necessary
      end
    end

    head :ok
  end

  private

  def authenticate_espago!
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.dig(:espago, :app_id) &&
      password == Rails.application.credentials.dig(:espago, :password)
    end
  end
end
