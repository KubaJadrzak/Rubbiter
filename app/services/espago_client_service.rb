require "net/http"
require "uri"
require "json"

class EspagoClientService
  def initialize(user:, password:)
    @user = user
    @password = password
  end

  def send(path, body: nil, method: :get)
    uri = URI.join("https://sandbox.espago.com", path)
    request = request_class(method).new(uri)
    request.basic_auth(@user, @password)
    request["Accept"] = "application/vnd.espago.v3+json"
    request["Content-Type"] = "application/json"
    request.body = body.to_json if body

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  private

  def request_class(method_name)
    Net::HTTP.const_get(method_name.to_s.capitalize)
  end
end
