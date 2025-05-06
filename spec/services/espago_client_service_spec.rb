require "rails_helper"
require "webmock/rspec"

RSpec.describe EspagoClientService, type: :service do
  let(:client) { described_class.new }

  let(:request_body) do
    {
      amount: 100,
      currency: "PLN",
      session_id: "fake_session_id",
      kind: "sale",
      checksum: "fake_checksum",
      title: "Order #1234",
      description: "Payment for Order #1234",
      positive_url: "http://localhost:3001/payments/payment_success?order_number=1234",
      negative_url: "http://localhost:3001/payments/payment_failure?order_number=1234",
    }
  end

  let(:request_headers) do
    {
      "Authorization" => "Basic #{Base64.strict_encode64("test_app_id:test_password")}",
      "Accept" => "application/vnd.espago.v3+json",
    }
  end

  before do
    allow(Rails.application.credentials).to receive(:dig).with(:espago, :app_id).and_return("test_app_id")
    allow(Rails.application.credentials).to receive(:dig).with(:espago, :password).and_return("test_password")
  end

  describe "#send" do
    context "when the request is successful" do
      before do
        stub_request(:post, "https://sandbox.espago.com/api/secure_web_page_register")
          .with(
            headers: request_headers,
            body: request_body,
          )
          .to_return(
            status: 200,
            body: { id: "payment_id_123", redirect_url: "https://sandbox.espago.com/secure_web_page/payment_id_123" }.to_json,
            headers: { "Content-Type" => "application/json" },
          )
      end

      it "returns a successful response with redirect URL" do
        response = client.send(
          "api/secure_web_page_register",
          method: :post,
          body: request_body,
        )

        expect(response.success?).to eq(true)
        expect(response.status).to eq(200)
        expect(response.body["redirect_url"]).to eq("https://sandbox.espago.com/secure_web_page/payment_id_123")
      end
    end

    context "when the request results in a connection failure" do
      before do
        stub_request(:post, "https://sandbox.espago.com/api/secure_web_page_register")
          .to_raise(Faraday::ConnectionFailed.new("Connection failed"))
      end

      it "returns a failed response with a connection error" do
        response = client.send(
          "api/secure_web_page_register",
          method: :post,
          body: request_body,
        )

        expect(response.success?).to eq(false)
        expect(response.status).to eq(:connection_failed)
        expect(response.body).to eq("Connection failed")
      end
    end

    context "when the request results in a 401 Unauthorized error" do
      before do
        stub_request(:post, "https://sandbox.espago.com/api/secure_web_page_register")
          .to_return(
            status: 401,
            body: { error: "Unauthorized" }.to_json,
            headers: { "Content-Type" => "application/json" },
          )
      end

      it "returns a failed response with status 401" do
        response = client.send(
          "api/secure_web_page_register",
          method: :post,
          body: request_body,
        )

        expect(response.success?).to eq(false)
        expect(response.status).to eq(401)
        expect(response.body["error"]).to eq("Unauthorized")
      end
    end
  end
end
