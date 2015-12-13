describe CrapiDocs::Session do
  let(:pattern) { /path/ }
  subject { described_class.new(pattern) }

  describe '#track' do
    it 'returns nil if request uri does not match the pattern' do
      req = double(:req, uri: 'hello')
      res = double(:res)
      expect(subject.track(req, res)).to be nil
    end

    it 'records the request and response if the uri does match' do
      uri = double(:uri, path: 'path', to_s: 'path')
      req = double(:req, uri: uri, method: 'GET')
      res = double(:res)

      subject.track(req, res)

      expected = { '/path' => { 'GET' => [{ req: req, res: res }] } }

      expect(subject.results).to eq expected
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
