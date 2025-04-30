class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :total_price, presence: true
  validates :status, presence: true
  validates :ordered_at, presence: true

  before_create :generate_order_number

  def calculate_total_price
    self.total_price = order_items.sum("quantity * price_at_purchase")
  end

  def build_order_items_from_cart(cart)
    cart.cart_items.each do |cart_item|
      order_items.build(
        product: cart_item.product,
        quantity: cart_item.quantity,
        price_at_purchase: cart_item.price,
      )
    end
  end

  def user_facing_payment_status
    case payment_status
    when "executed"
      "Paid"
    when "rejected", "failed", "resigned", "reversed", "connection failed"
      "Failed"
    when "preauthorized", "tds2_challenge", "tds_redirected", "dcc_decision", "blik_redirected", "transfer_redirected", "new"
      "Awaiting Confirmation"
    when "refunded"
      "Refunded"
    when "Processing"
      "Processing"
    else
      "Unkown"
    end
  end

  private

  def generate_order_number
    self.order_number = SecureRandom.hex(10).upcase
  end
end
