require 'active_support/all'
require 'rack/test'

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
  VERSION = [0, 1, 4]
  TEMPLATE_DIR = File.expand_path('../..', __FILE__) + '/templates'
  PARALLEL = ENV['PARALLEL_TEST_GROUPS'] && defined?(ParallelTests)

  class << self
    attr_reader :session

    def version
      VERSION.join('.')
    end

    def start(pattern, target = './doc/api.md')
      @session = Session.new(pattern)
      @target = target
      @tmp = './tmp'
    end

    def purge
      @session = nil
    end

    def on?
      @session.present?
    end

    def done
      handle_parallel if CrapiDocs::PARALLEL
      formatter = Formatter.new(@session)
      write_file(formatter.to_md)
    end

    private

    def handle_parallel
      return write_session unless ParallelTests.first_process?

      ParallelTests.wait_for_other_processes_to_finish

      @session.merge(load_sessions)
    end

    def write_session
      file = format('%s/crapi-session.%d', @tmp, ENV['TEST_ENV_NUMBER'])
      File.open(file, 'w') { |f| f.write(Marshal.dump(@session)) }
    end

    def load_sessions
      Dir["#{@tmp}/crapi-session.*"].map do |f|
        data = File.open(f).read
        File.unlink(f)
        Marshal.load(data)
      end
    end

    def write_file(data)
      File.open(@target, 'w') { |f| f.write(data) }
    end
  end
end

at_exit { CrapiDocs.done if CrapiDocs.on? }
