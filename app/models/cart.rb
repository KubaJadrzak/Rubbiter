class Cart < ApplicationRecord
  belongs_to :user, optional: true  # allow guest carts
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_price
    cart_items.sum(&:total_price)
  end
end
