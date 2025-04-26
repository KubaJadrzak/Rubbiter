class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @cart = current_user.cart
    @product = Product.find(params[:product_id])

    @cart_item = @cart.cart_items.find_by(product_id: @product.id)

    if @cart_item
      @cart_item.increment!(:quantity)
    else
      @cart.cart_items.create!(product: @product, quantity: 1, price: @product.price)
    end

    redirect_to products_path, notice: "#{@product.title} added to cart!"
  end

  before_action :authenticate_user!

  def destroy
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end
end
