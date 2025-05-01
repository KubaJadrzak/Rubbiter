require "faraday"
require "json"
require "base64"
require "ostruct"

class EspagoClientService
  BASE_URL = "https://sandbox.espago.com"

  def initialize
    @user = Rails.application.credentials.dig(:espago, :app_id)
    @password = Rails.application.credentials.dig(:espago, :password)

    @conn = Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :json
      faraday.response :raise_error
      faraday.response :logger if Rails.env.development?
      faraday.adapter Faraday.default_adapter
    end
  end

  def send(path, body: nil, method: :get)
    response = @conn.send(method) do |req|
      req.url path
      req.headers["Accept"] = "application/vnd.espago.v3+json"
      req.headers["Content-Type"] = "application/json"
      req.headers["Authorization"] = "Basic #{encoded_credentials}"
      req.body = body.to_json if body
    end

    response
  rescue Faraday::Error => e
    Rails.logger.error("Faraday request failed: #{e.message}")
    OpenStruct.new(success?: false, status: 500, body: { error: e.message }.to_json)
  end

  private

  def encoded_credentials
    Base64.strict_encode64("#{@user}:#{@password}")
  end
end
