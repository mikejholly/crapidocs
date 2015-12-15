require_relative './lib/crapidocs'

Gem::Specification.new do |s|
  s.name        = 'crapidocs'
  s.version     = CrapiDocs.version
  s.licenses    = ['MIT']
  s.summary     = 'Crazy Rspec API Docs'
  s.description = 'Generate decent API documentation from RSpec API tests.'
  s.authors     = ['Mike Holly']
  s.email       = 'mikejholly@gmail.com'
  s.files       = Dir['lib/**/**', 'templates/*']
  s.homepage    = 'https://rubygems.org/gems/crapidocs'
end
