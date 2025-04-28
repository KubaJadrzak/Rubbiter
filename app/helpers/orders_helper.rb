module OrdersHelper
  def order_status_badge(order)
    case order.status
    when "Preparing for Shipment"
      { class: "bg-success", text: order.status }
    when "Payment Failed"
      { class: "bg-danger", text: order.status }
    when "Waiting for Payment"
      { class: "bg-warning", text: order.status }
    when "Payment Refunded"
      { class: "bg-primary", text: order.status }
    else
      { class: "bg-secondary", text: order.status }
    end
  end

  def payment_status_badge(order)
    case order.payment_status
    when "Paid"
      { class: "bg-success", text: order.payment_status }
    when "Failed"
      { class: "bg-danger", text: order.payment_status }
    when "Pending"
      { class: "bg-warning", text: order.payment_status }
    when "Refunded"
      { class: "bg-primary", text: order.payment_status }
    else
      { class: "bg-secondary", text: order.payment_status }
    end
  end
end
