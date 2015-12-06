require 'rack/test'
require 'active_support/all'

require_relative 'crapidocs/formatter'
require_relative 'crapidocs/request'
require_relative 'crapidocs/response'
require_relative 'crapidocs/session'

module Rack
  class MockSession
    method = instance_method(:request)
    define_method(:request) do |*args, &block|
      result = method.bind(self).call(*args, &block)
      req = CrapiDocs::Request.new(*args)
      res = CrapiDocs::Response.new(*result)
      CrapiDocs.session.track(req, res)
      result
    end
  end
end

module CrapiDocs
  VERSION = [0, 1]

  class << self
    attr_reader :session

    def version
      VERSION.join('.')
    end

    def start(pattern, target = './doc/api.md')
      @session = Session.new(pattern)
      @target = target
    end

    def purge
      @session = nil
    end

    def on?
      @session.present?
    end

    def done
      formatter = Formatter.new(@session)
      write_file(formatter.to_md)
    end

    private

    def write_file(data)
      File.open(@target, 'w').write(data)
    end
  end
end
