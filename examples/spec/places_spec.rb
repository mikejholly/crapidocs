describe '/places' do
  include Rack::Test::Methods

  describe 'GET /places' do
    it 'returns places' do
      get_json '/places'
    end
  end

  describe 'GET /places/:id' do
    it 'return a place' do
      get_json '/places/1'
    end
  end

  describe 'POST /places' do
    it 'creates a place and returns it' do
      post_json '/places', name: 'Vancouver'
    end
  end
end
