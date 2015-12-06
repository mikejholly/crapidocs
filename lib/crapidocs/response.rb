module CrapiDocs
  class Response
    attr_accessor :status, :headers, :body

    def initialize(status, headers, body)
      @status = status
      @headers = headers
      @body = body.respond_to?(:body) ? body.body : ''
    end
  end
end
