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
      status: "pending",
      payment_status: "payed",
      ordered_at: Time.current,
    )

    # Build order items from cart
    @order.build_order_items_from_cart(current_user.cart)

    if @order.save
      current_user.cart.cart_items.destroy_all
      redirect_to orders_path, notice: "Order placed successfully!"
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:country, :street, :postal_code)
  end
end
