class CartsController < ApplicationController
  before_action :set_cart, only: [:show]

  private

  def set_cart
    @cart = current_user.cart
  end
end
