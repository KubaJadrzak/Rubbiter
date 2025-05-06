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
      faraday.response :json

      faraday.response :logger if Rails.env.development?
      faraday.adapter Faraday.default_adapter
    end
  end

  def send(path, body: nil, method: :get)
    response = @conn.send(method) do |req|
      req.url path
      req.headers["Accept"] = "application/vnd.espago.v3+json"
      req.headers["Authorization"] = "Basic #{encoded_credentials}"
      req.body = body if body
    end

    OpenStruct.new(success?: true, status: response.status, body: response.body)
  rescue Faraday::Error => e
    if e.respond_to?(:response)
      Rails.logger.error("EspagoClientService status: #{e.response[:status]}, body: #{e.response[:body]}")
      case e.response[:status]
      when 401
        error_message = e.response[:body]["error"]
        return OpenStruct.new(success?: false, status: 401, body: { error: error_message }.to_json)
      when 422
        error_messages = e.response[:body]["errors"] || []
        return OpenStruct.new(success?: false, status: 422, body: { errors: error_messages }.to_json)
      when 500
        error_message = e.response[:body]["error"]
        return OpenStruct.new(success?: false, status: 500, body: { error: error_message }.to_json)
      else
        Rails.logger.error("EspagoClientService status: #{e.repsonse[:status]}, body:  #{e.message}")
        return OpenStruct.new(success?: false, status: e.response[:status], body: { error: e.message }.to_json)
      end
    end

    OpenStruct.new(success?: false, status: 500, body: { error: e.message }.to_json)
  end

  private

  def encoded_credentials
    Base64.strict_encode64("#{@user}:#{@password}")
  end
end
