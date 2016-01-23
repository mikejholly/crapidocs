describe CrapiDocs::Formatter do
  let(:session) { double }
  subject { CrapiDocs::Formatter.new(session) }

  describe '#anchor' do
    it 'creates an link anchor with all special chars removed' do
      result = subject.send(:anchor, 'foo-bar_1@')
      expect(result).to eq 'foobar1'
    end
  end
end
