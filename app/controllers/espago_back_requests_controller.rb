class EspagoBackRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:handle_back_request]
  before_action :authenticate_espago!

  def handle_back_request
    payload = JSON.parse(request.body.read)

    order_number = extract_order_number(payload["description"])

    # Find the order based on the order number
    order = Order.find_by(order_number: order_number)

    # Assign payment_status and status to order
    if order
      case payload["state"]
      when "executed"
        order.update(payment_status: "executed", status: "Preparing for Shipment")
      when "rejected"
        order.update(payment_status: "rejected", status: "Failed")
      when "failed"
        order.update(payment_status: "failed", status: "Failed")
      when "preauthorized"
        order.update(payment_status: "preauthorized", status: "Waiting for Payment")
      when "tds2_challenge"
        order.update(payment_status: "tds2_challenge", status: "Waiting for Payment")
      when "tds_redirected"
        order.update(payment_status: "tds_redirected", status: "Waiting for Payment")
      when "dcc_decision"
        order.update(payment_status: "dcc_decision", status: "Waiting for Payment")
      when "resigned"
        order.update(payment_status: "resigned", status: "Failed")
      when "reversed"
        order.update(payment_status: "reversed", status: "Failed")
      when "refunded"
        order.update(payment_status: "refunded", status: "Failed")
      when "blik_redirected"
        order.update(payment_status: "blik_redirected", status: "Waiting for Payment")
      when "transfer_redirected"
        order.update(payment_status: "transfer_redirected", status: "Waiting for Payment")
      else
        # Handle unknown state if necessary
      end
    else
      # Handle case where the order is not found
    end

    # Respond with HTTP 200 OK as per the API documentation
    head :ok
  end

  private

  # Basic Auth for security
  def authenticate_espago!
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.dig(:espago, :app_id) &&
      password == Rails.application.credentials.dig(:espago, :password)
    end
  end

  def extract_order_number(description)
    # Find the part of the string starting with '#'
    match = description.match(/#\w+/)

    # If a match is found, return the order number without the '#'
    if match
      match[0][1..-1]
    else
      nil
    end
  end
end
