describe CrapiDocs::Session do
  let(:pattern) { /path/ }
  let(:uri_path) { '/path/to/thing' }
  let(:uri) { double(:uri, to_s: uri_path, path: uri_path) }
  let(:env) do
    { 'REQUEST_METHOD' => 'GET',
      'rack.input' => double(:input, string: 'foo') }
  end
  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { { foo: 1 }.to_json }
  let(:args) { [uri, env] }
  let(:result) { [status, headers, body] }

  subject { described_class.new(pattern) }

  describe '#track' do
    it 'records the request and response' do
      subject.track(args, result)
      expect(subject.actions).to include
      expect(subject.actions[uri_path]).to include 'GET'
      expect(subject.actions[uri_path]['GET'].length).to eq 1
      expect(subject.actions[uri_path]['GET'][0]).to include :request, :response
    end

    context 'uri does not match the desired pattern' do
      let(:uri_path) { 'non/match' }
      it 'returns nil' do
        expect(subject.track(args, result)).to be nil
      end
    end
  end

  describe '#clean_path' do
    it 'replaces numeric path components with a meaningful name' do
      path = '/things/123/foo'
      expect(subject.send(:clean_path, path)).to eq '/things/:thing_id/foo'
    end

    it 'handles plurals correctly' do
      path = '/people/123/foo'
      expect(subject.send(:clean_path, path)).to eq '/people/:person_id/foo'
    end

    it 'removes empty path components (double slashes)' do
      path = '/people/123//foo'
      expect(subject.send(:clean_path, path)).to eq '/people/:person_id/foo'
    end

    it 'replaces token-like components with :token' do
      path = '/people/lkasldfk3lkl23klasdf232/foo'
      expect(subject.send(:clean_path, path)).to eq '/people/:token/foo'
    end
  end

  describe '#tokenish?' do
    it 'returns true if the path component is token-like' do
      part = 'asdf23423aweras234'
      expect(subject.send(:tokenish?, part)).to be true
    end

    it 'returns true if the path component is not token-like' do
      part = 'path'
      expect(subject.send(:tokenish?, part)).to be false
    end
  end

  describe '#relevant?' do
    it 'returns true if the uri matches the pattern' do
      expect(subject.send(:relevant?, 'path')).to be true
    end

    it 'returns false if the uri does not match the pattern' do
      expect(subject.send(:relevant?, 'foo')).to be false
    end
  end
end
