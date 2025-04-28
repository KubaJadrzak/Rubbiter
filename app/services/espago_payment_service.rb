class EspagoPaymentService
  def initialize(order)
    @order = order
  end

  def create_payment
    session_id = SecureRandom.hex(16)
    amount = @order.total_price
    ts = Time.now.to_i

    checksum = EspagoChecksumService.generate(
      kind: "sale",
      session_id: session_id,
      amount: amount,
      currency: "PLN",
      ts: ts,
    )

    client = EspagoClientService.new(
      user: Rails.application.credentials.dig(:espago, :app_id),
      password: Rails.application.credentials.dig(:espago, :password),
    )

    response = client.send(
      "api/secure_web_page_register",
      method: :post,
      body: {
        amount: amount,
        currency: "PLN",
        description: "Payment for Order ##{@order.order_number}",
        kind: "sale",
        session_id: session_id,
        title: "Order ##{@order.order_number}",
        checksum: checksum,
      },
    )

    response
  end
end
