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
      formatter = double(:formatter, to_md: '')
      expect(CrapiDocs::Formatter)
        .to receive(:new)
        .with(subject.session)
        .and_return formatter
      allow(subject).to receive(:write_file).and_return true
      subject.done
    end

    it 'calls write_file with content' do
      formatter = double(:formatter, to_md: '')
      expect(CrapiDocs::Formatter)
        .to receive(:new)
        .with(subject.session)
        .and_return formatter
      expect(subject).to receive(:write_file).and_return true
      subject.done
    end
  end

  describe '.handle_parallel' do
    before { subject.start(pattern) }

    before do
      stub_const('ParallelTests', double)
      allow(ParallelTests)
        .to receive(:wait_for_other_processes_to_finish)
        .and_return(true)
    end

    context 'is the first parallel test process' do
      it 'loads other sessions and merges' do
        expect(subject).to receive(:load_sessions).and_return([])
        expect(subject.session).to receive(:merge).with([])
        allow(ParallelTests).to receive(:first_process?).and_return(true)
        subject.send(:handle_parallel)
      end
    end

    context 'is another process' do
      it 'writes out its session data' do
        allow(ParallelTests).to receive(:first_process?).and_return(false)
        expect(subject).to receive(:write_session).and_return(true)
        subject.send(:handle_parallel)
      end
    end
  end

  describe '.session_file' do
    it 'generates a file name for the test env' do
      result = subject.send(:session_file)
      expect(result).to eq './tmp/crapi-session.1'
    end

    context 'another test number' do
      it 'generates a file name for the test env' do
        ENV['TEST_ENV_NUMBER'] = '2'
        result = subject.send(:session_file)
        expect(result).to eq './tmp/crapi-session.2'
      end
    end
  end

  describe '.write_session' do
    it 'marshals the session and writes' do
      expect(subject)
        .to receive(:write_file)
        .with('./tmp/crapi-session.2', Marshal.dump(subject.session))
      subject.send(:write_session)
    end
  end
end
