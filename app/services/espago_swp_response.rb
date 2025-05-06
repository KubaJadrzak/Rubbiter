class EspagoSwpResponse
  attr_reader :success, :status, :body

  def initialize(success:, status:, body:)
    @success = success
    @status = status
    @body = body
  end

  def success?
    @success
  end
end
