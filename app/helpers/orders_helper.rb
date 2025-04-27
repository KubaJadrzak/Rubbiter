module OrdersHelper
  def order_status_badge(order)
    case order.status
    when "Preparing for Shipment"
      { class: "bg-success", text: "Preparing for Shipment" }
    when "Failed"
      { class: "bg-danger", text: "Payment Failed" }
    when "Waiting for Payment"
      { class: "bg-warning", text: "Waiting for Payment" }
    else
      { class: "bg-secondary", text: "Created" }
    end
  end

  def payment_status_badge(order)
    case order.payment_status
    when "executed"
      { class: "bg-success", text: "Payment Completed" }
    when "rejected"
      { class: "bg-danger", text: "Payment Rejected" }
    when "failed"
      { class: "bg-danger", text: "Payment Failed" }
    when "preauthorized"
      { class: "bg-warning", text: "Pre-authorization" }
    when "tds2_challenge"
      { class: "bg-info", text: "Awaiting 3D-Secure Authentication" }
    when "tds_redirected"
      { class: "bg-info", text: "Redirected to 3D-Secure" }
    when "dcc_decision"
      { class: "bg-info", text: "Awaiting Currency Decision" }
    when "resigned"
      { class: "bg-secondary", text: "Payment Abandoned" }
    when "reversed"
      { class: "bg-dark", text: "Payment Reversed" }
    when "refunded"
      { class: "bg-primary", text: "Refunded" }
    when "blik_redirected"
      { class: "bg-info", text: "Awaiting BLIK Code" }
    when "transfer_redirected"
      { class: "bg-info", text: "Awaiting Bank Transfer" }
    else
      { class: "bg-secondary", text: "Awaiting Payment Status" }
    end
  end
end
