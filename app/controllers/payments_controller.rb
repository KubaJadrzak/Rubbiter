class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def start_payment
    @order = Order.find(params[:order_id])

    payment_service = EspagoPaymentService.new(@order)
    response = payment_service.create_payment

    Rails.logger.info "Espago Payment Response: #{response.inspect}"

    if response.success?
      data = response.body
      @order.update(payment_id: data["id"])
      redirect_to data["redirect_url"], allow_other_host: true
    else
      error_data = response.body
      @order.update(payment_id: error_data["id"], payment_status: "connection failed", status: "Payment Failed")
      redirect_to order_path(@order), alert: "We are experiencing an issue with payment service"
    end
  end

  def payment_success
    @order = Order.find_by(order_number: params[:order_number])

    if @order
      redirect_to order_path(@order), notice: "Payment successful!"
    else
      redirect_to orders_path, alert: "We are experiencing an issue with your order"
    end
  end

  def payment_failure
    @order = Order.find_by(order_number: params[:order_number])

    if @order
      redirect_to order_path(@order), alert: "Payment failed!"
    else
      redirect_to orders_path, alert: "We are experiencing an issue with your order"
    end
  end
end
