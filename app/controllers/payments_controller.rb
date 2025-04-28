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
    redirect_to orders_path, notice: "Payment successful!"
  end

  # handle user redirect from Espago payment site after failure (negative_url)
  def payment_failure
    redirect_to orders_path, alert: "Payment failed. Please try again."
  end
end
