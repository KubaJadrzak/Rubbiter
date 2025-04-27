class EspagoChecksumService
  require "digest"

  def self.generate(kind:, session_id:, amount:, currency:, ts:)
    app_id = Rails.application.credentials.dig(:espago, :app_id)
    checksum_key = Rails.application.credentials.dig(:espago, :checksum_key)

    raw_string = "#{app_id}#{kind}#{session_id}#{amount}#{currency}#{ts}#{checksum_key}"
    Digest::MD5.hexdigest(raw_string)
  end
end
