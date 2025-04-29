require "rails_helper"

RSpec.describe EspagoChecksumService, type: :service do
  describe ".generate" do
    let(:kind) { "sale" }
    let(:session_id) { SecureRandom.hex(16) }
    let(:amount) { 100.0 }
    let(:currency) { "PLN" }
    let(:ts) { Time.now.to_i }
    let(:app_id) { Rails.application.credentials.dig(:espago, :app_id) }
    let(:checksum_key) { Rails.application.credentials.dig(:espago, :checksum_key) }

    it "generates the correct checksum" do
      raw_string = "#{app_id}#{kind}#{session_id}#{amount}#{currency}#{ts}#{checksum_key}"
      expected_checksum = Digest::MD5.hexdigest(raw_string)

      checksum = described_class.generate(
        kind: kind,
        session_id: session_id,
        amount: amount,
        currency: currency,
        ts: ts,
      )

      expect(checksum).to eq(expected_checksum)
    end
  end
end
