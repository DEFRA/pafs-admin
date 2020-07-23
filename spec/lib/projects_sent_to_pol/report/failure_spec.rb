# frozen_string_literal: true

describe ProjectsSentToPol::Report::Failure do
  subject { described_class.new }

  context 'with a project that failed to send to pol' do
    let!(:project) { create(:project, :submitted, submitted_to_pol: nil) }

    it 'returns false for #empty' do
      expect(subject.empty?).to be_falsey
    end

    it 'returns 1 for size' do
      expect(subject.size).to eql(1)
    end
  end

  context 'with a project sent two days ago' do
    let!(:project) { create(:project, :submitted, submitted_to_pol: 2.days.ago) }

    it 'returns true for #empty' do
      expect(subject.empty?).to be_truthy
    end

    it 'returns 0 for size' do
      expect(subject.size).to eql(0)
    end
  end
end
