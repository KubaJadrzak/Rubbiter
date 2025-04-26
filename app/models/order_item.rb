class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true
  validates :price_at_purchase, presence: true

  def total_price
    price_at_purchase * quantity
  end
end
