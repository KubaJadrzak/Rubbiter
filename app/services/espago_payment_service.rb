require "digest"

class EspagoPaymentService
  def initialize(order)
    @order = order
  end

  def create_payment
    base_host = ENV.fetch("APP_HOST_URL")
    session_id = SecureRandom.hex(16)
    amount = @order.total_price
    ts = Time.now.to_i

    checksum = generate_checksum(
      kind: "sale",
      session_id: session_id,
      amount: amount,
      currency: "PLN",
      ts: ts,
    )

    client = EspagoClientService.new

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
        positive_url: "#{base_host}/payments/payment_success?order_number=#{@order.order_number}",
        negative_url: "#{base_host}/payments/payment_failure?order_number=#{@order.order_number}",
      },
    )

    response
  end

  def generate_checksum(kind:, session_id:, amount:, currency:, ts:)
    app_id = Rails.application.credentials.dig(:espago, :app_id)
    checksum_key = Rails.application.credentials.dig(:espago, :checksum_key)
    raw_string = "#{app_id}#{kind}#{session_id}#{amount}#{currency}#{ts}#{checksum_key}"
    Digest::MD5.hexdigest(raw_string)
  end
end
