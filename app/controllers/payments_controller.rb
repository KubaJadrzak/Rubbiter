class PaymentsController < ApplicationController
  def start_payment
    @order = Order.find(params[:order_id])

    payment_service = EspagoPaymentService.new(@order)
    response = payment_service.create_payment

    Rails.logger.info "Espago Payment Response: #{response.inspect}"

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      @order.update(payment_id: data["id"])
      redirect_to data["redirect_url"], allow_other_host: true
    else
      @order.update(payment_status: "Failed", status: "Payment Failed")
      redirect_to order_path(@order), alert: "Payment failed. Please try again."
    end
  end

  def payment_success
    @order = Order.find_by(order_number: params[:order_number])

    if @order
      @order.update(payment_status: "Paid", status: "Preparing for Shipment")
      redirect_to order_path(@order), notice: "Payment successful!"
    else
      redirect_to orders_path, alert: "Order not found."
    end
  end

  def payment_failure
    @order = Order.find_by(order_number: params[:order_number])

    if @order
      @order.update(payment_status: "Failed", status: "Payment Failed")
      redirect_to order_path(@order), alert: "Payment failed. Please try again."
    else
      redirect_to orders_path, alert: "Order not found."
    end
  end
end
