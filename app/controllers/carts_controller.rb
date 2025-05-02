class CartsController < ApplicationController
  before_action :set_cart, only: [:show]

  def checkout
    @cart = current_user.cart
    if @cart.cart_items.any?
      redirect_to new_order_path, notice: "Please enter your order details to complete the purchase."
    else
      redirect_to cart_path, alert: "Your cart is empty."
    end
  end

  private

  def set_cart
    @cart = current_user.cart
  end
end
