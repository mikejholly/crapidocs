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
  VERSION = [0, 2, 1]
  TEMPLATE_DIR = File.expand_path('../..', __FILE__) + '/templates'
  PARALLEL = ENV['PARALLEL_TEST_GROUPS'] && defined?(ParallelTests)
  SESSION_FILE_PREFIX = 'crapi-session.'

  class << self
    attr_reader :session

    def version
      VERSION.join('.')
    end

    def start(pattern, target = './doc/api.md', tmp = './tmp')
      @session = Session.new(pattern)
      @target = target
      @tmp = tmp
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
      write_docs(formatter.to_md)
    end

    private

    def handle_parallel
      return write_session unless ParallelTests.first_process?
      ParallelTests.wait_for_other_processes_to_finish
      @session.merge(load_sessions)
    end

    def session_file
      test_num = ENV['TEST_ENV_NUMBER'] || '1'
      format('%s/%s%s', @tmp, SESSION_FILE_PREFIX, test_num)
    end

    def write_session
      write_file(session_file, Marshal.dump(@session))
    end

    def load_sessions
      glob = "#{@tmp}/#{SESSION_FILE_PREFIX}*"
      Dir[glob].map { |f| load_session(f) }
    end

    def load_session(file)
      data = File.open(file).read
      File.unlink(file)
      Marshal.load(data)
    end

    def write_docs(data)
      write_file(@target, data)
    end

    def write_file(file, data)
      File.open(file, 'w') { |f| f.write(data) }
    end
  end
end

at_exit { CrapiDocs.done if CrapiDocs.on? }
