class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def new
    @order = Order.new
  end

  def index
    @orders = current_user.orders.order(ordered_at: :desc)
  end

  def create
    shipping_address = "#{params[:order][:country]}, #{params[:order][:street]}, #{params[:order][:postal_code]}"

    @order = current_user.orders.new(
      shipping_address: shipping_address,
      total_price: current_user.cart.total_price,
      status: "created",
      payment_status: "pending",
      ordered_at: Time.current,
    )

    # Build order items from cart
    @order.build_order_items_from_cart(current_user.cart)

    if @order.save
      current_user.cart.cart_items.destroy_all
      redirect_to pay_order_path(@order)
    else
      render :new
    end
  end

  def pay
    @order = current_user.orders.find(params[:id])

    session_id = SecureRandom.hex(16)
    amount = @order.total_price
    ts = Time.now.to_i

    checksum = EspagoHelper.generate_espago_checksum(
      kind: "sale",
      session_id: session_id,
      amount: amount,
      currency: "PLN",
      ts: ts,
    )

    client = EspagoClient.new(
      user: Rails.application.credentials.dig(:espago, :app_id),
      password: Rails.application.credentials.dig(:espago, :password),
    )
    response = client.send(
      "api/secure_web_page_register",
      method: :post,
      body: {
        amount: amount,
        currency: "PLN",
        description: "Payment for Order ##{@order.order_number}",
        kind: "sale",
        session_id: session_id,
        title: "Order ##{@order.order_number}",
        checksum: checksum,
      },
    )
    puts "Espago login user: #{Rails.application.credentials.dig(:espago, :app_id)}"
    puts "Espago login password: #{Rails.application.credentials.dig(:espago, :password)}"

    puts "Espago response code: #{response.code}"
    puts "Espago response body: #{response.body}"

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      redirect_to data["redirect_url"], allow_other_host: true
    else
      redirect_to root_path, alert: "There was an issue with the payment gateway."
    end
  end

  private

  def order_params
    params.require(:order).permit(:country, :street, :postal_code)
  end
end
