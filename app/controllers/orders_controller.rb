class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def new
    @order = Order.new
  end

  def index
    @orders = current_user.orders.order(ordered_at: :desc)
  end

  def create
    # Construct shipping address
    shipping_address = "#{params[:order][:country]}, #{params[:order][:street]}, #{params[:order][:postal_code]}"

    # Create a new order object for the current user
    @order = current_user.orders.new(
      shipping_address: shipping_address,
      total_price: current_user.cart.total_price,
      status: "created",
      payment_status: "pending",
      ordered_at: Time.current,
    )

    # Build order items from the current user's cart
    @order.build_order_items_from_cart(current_user.cart)

    if @order.save
      # Clear the cart after saving the order
      current_user.cart.cart_items.destroy_all
      Rails.logger.info "Order created, redirecting to payment"

      # Redirect to the payment creation (where the payment gateway is called)
      redirect_to start_payment_path(order_id: @order.id)
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:country, :street, :postal_code)
  end
end
