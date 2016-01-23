ENV['RACK_ENV'] = 'test'

require 'rack'
require 'pry'
require 'rack/test'
require 'parallel_tests'

require_relative '../app'
require_relative '../../lib/crapidocs'
require_relative '../helpers'

CrapiDocs.start(%r{/}, 'api.md')

RSpec.configure do |c|
  c.include Helpers
end
