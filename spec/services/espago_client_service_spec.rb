require "faraday"
require "json"
require "base64"
require "ostruct"

RSpec.describe EspagoClientService do
  let(:client) { described_class.new }
  let(:path) { "/api/test_endpoint" }
  let(:url) { "https://sandbox.espago.com#{path}" }

  before do
    allow(Rails.application.credentials).to receive(:dig).with(:espago, :app_id).and_return("test_user")
    allow(Rails.application.credentials).to receive(:dig).with(:espago, :password).and_return("test_pass")
  end

  describe "#send" do
    context "when request is successful" do
      before do
        stub_request(:post, url)
          .with(
            headers: {
              "Accept" => "application/vnd.espago.v3+json",
              "Content-Type" => "application/json",
              "Authorization" => /Basic .+/,
            },
            body: { test: "ok" }.to_json,
          )
          .to_return(status: 200, body: { response: "ok" }.to_json)
      end

      it "returns a successful Faraday response" do
        response = client.send(path, method: :post, body: { test: "ok" })

        expect(response.status).to eq(200)
        expect(response.body).to include("ok")
      end
    end

    context "when request fails" do
      before do
        stub_request(:get, url).to_raise(Faraday::ConnectionFailed.new("Connection error"))
      end

      it "returns an OpenStruct with failure" do
        response = client.send(path)

        expect(response).to be_a(OpenStruct)
        expect(response.success?).to eq(false)
        expect(response.status).to eq(500)
        expect(JSON.parse(response.body)["error"]).to include("Connection error")
      end
    end
  end
end
