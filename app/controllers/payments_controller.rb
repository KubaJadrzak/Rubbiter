class PaymentsController < ApplicationController
  def start_payment
    @order = Order.find(params[:order_id])

    payment_service = EspagoPaymentService.new(@order)
    response = payment_service.create_payment

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      @order.update(payment_id: data["id"])
      redirect_to data["redirect_url"], allow_other_host: true
    else
      redirect_to root_path, alert: "There was an issue with the payment gateway."
    end
  end

  # handle user redirect from Espago payment site after success (positive_url)
  def payment_success
    @order = Order.find_by(order_number: params[:order_number])

    if @order
      redirect_to order_path(@order), notice: "Payment successful!"
    else
      redirect_to orders_path, alert: "Order not found."
    end
  end

  # Handle user redirect from Espago payment site after failure (negative_url)
  def payment_failure
    @order = Order.find_by(order_number: params[:order_number])

    if @order
      redirect_to order_path(@order), alert: "Payment failed. Please try again."
    else
      redirect_to orders_path, alert: "Order not found."
    end
  end
end
