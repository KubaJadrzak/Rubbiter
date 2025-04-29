class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :set_order, only: [:show]

  def new
    @order = Order.new
  end

  def index
    @orders = current_user.orders.order(ordered_at: :desc)
  end

  def show
    @order
  end

  def create
    shipping_address = "#{params[:order][:country]}, #{params[:order][:street]}, #{params[:order][:postal_code]}"

    @order = current_user.orders.new(
      shipping_address: shipping_address,
      total_price: current_user.cart.total_price,
      status: "Created",
      payment_status: "Initialized",
      ordered_at: Time.current,
    )

    @order.build_order_items_from_cart(current_user.cart)

    if @order.save
      current_user.cart.cart_items.destroy_all
      redirect_to start_payment_path(order_id: @order.id)
    else
      render :new
    end
  end

  private

  def set_order
    @order = Order.find_by!(id: params[:id])
  end

  def order_params
    params.require(:order).permit(:country, :street, :postal_code)
  end
end
