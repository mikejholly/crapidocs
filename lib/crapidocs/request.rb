module CrapiDocs
  class Request
    attr_accessor :uri, :env

    def initialize(uri, env)
      @uri = uri
      @env = env
    end

    def method
      @env['REQUEST_METHOD']
    end

    def headers
      @env['HEADERS']
    end

    def input
      @env['rack.input'].string
    end
  end
end
