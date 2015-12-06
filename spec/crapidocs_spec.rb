describe CrapiDocs do
  subject { CrapiDocs }
  let(:pattern) { /path/ }
  after { subject.purge }

  it 'has a version const' do
    expect(subject::VERSION).to be_a Array
  end

  describe '.version' do
    it 'returns the version as a string' do
      expect(subject.version).to eq subject::VERSION.join('.')
    end
  end

  describe '.start' do
    it 'creates a new session and' do
      subject.start(pattern)
      expect(subject.session).to be_a CrapiDocs::Session
    end

    it 'defaults the output file' do
      subject.start(pattern)
      expect(subject.instance_variable_get(:@target)).to eq './doc/api.md'
    end
  end

  describe '.purge' do
    it 'sets the session to nil' do
      subject.start(pattern)
      subject.purge
      expect(subject.session).to be_nil
    end
  end

  describe '.on?' do
    it 'returns false when start has not been called' do
      expect(subject.on?).to be false
    end

    it 'returns false when start has not been called' do
      subject.start(pattern)
      expect(subject.on?).to be true
    end
  end

  describe '.done' do
    before { subject.start(pattern) }

    it 'creates a formatter and generates markdown' do
      expect(CrapiDocs::Formatter)
        .to receive(:new)
        .with(subject.session)
        .and_call_original
    end

    it 'calls write_file with content' do
      expect(subject).to receive(:write_file).and_return true
      subject.done
    end
  end
end
