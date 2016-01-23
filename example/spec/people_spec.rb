describe '/people' do
  include Rack::Test::Methods

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
