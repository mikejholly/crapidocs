ENV['RACK_ENV'] = 'test'

require 'pry'
require 'rack/test'

require_relative 'app'
require_relative '../lib/crapidocs'

CrapiDocs.start(%r{/}, 'api.md')
at_exit { CrapiDocs.done if CrapiDocs.on? }

describe 'App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def get_json(path)
    get path, nil, 'Content-Type' => 'application/json'
  end

  def post_json(path, body)
    post path, body.to_json, 'Content-Type' => 'application/json'
  end

  describe 'GET /people' do
    it 'returns people' do
      get_json '/people'
    end
  end

  describe 'GET /people/:id' do
    it 'return a person' do
      get_json '/people/1'
    end
  end

  describe 'POST /people' do
    it 'creates a person and returns it' do
      post_json '/people', name: 'Bob'
    end
  end
end
