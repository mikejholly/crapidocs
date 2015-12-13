require 'rack/test'
require 'active_support/all'

require_relative 'crapidocs/formatter'
require_relative 'crapidocs/session'

module Rack
  class MockSession
    method = instance_method(:request)
    define_method(:request) do |*args, &block|
      result = method.bind(self).call(*args, &block)
      CrapiDocs.session.track(args, result)
      result
    end
  end
end

module CrapiDocs
  VERSION = [0, 1]
  TEMPLATE_DIR = File.expand_path('../..', __FILE__) + '/templates'

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

at_exit { CrapiDocs.done if CrapiDocs.on? }
