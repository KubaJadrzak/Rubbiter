class PaymentsController < ApplicationController
  def start_payment
    # find order for which payment should be initilized
    @order = Order.find(params[:order_id])

    # register payment for order
    payment_service = EspagoPaymentService.new(@order)
    # assign response received from Espago
    response = payment_service.create_payment

    if response.is_a?(Net::HTTPSuccess)
      # if response contains Espago redirect url, redirect user there
      data = JSON.parse(response.body)
      @order.update(payment_id: data["id"])
      redirect_to data["redirect_url"], allow_other_host: true
    else
      # if response doesn't contain Espago redirect url, redirect user to root
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
