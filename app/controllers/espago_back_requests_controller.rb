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
        order.update(payment_status: payload["state"], status: "Preparing for Shipment")
      when "rejected"
        order.update(ayment_status: payload["state"], status: "Failed")
      when "failed"
        order.update(ayment_status: payload["state"], status: "Failed")
      when "preauthorized", "tds2_challenge", "tds_redirected", "dcc_decision", "blik_redirected", "transfer_redirected"
        order.update(payment_status: payload["state"], status: "Waiting for Payment")
      when "resigned", "reversed", "refunded"
        order.update(payment_status: payload["state"], status: "Failed")
      else
      end
    else
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
