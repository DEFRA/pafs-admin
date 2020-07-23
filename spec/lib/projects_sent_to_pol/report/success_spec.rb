# frozen_string_literal: true

describe ProjectsSentToPol::Report::Success do
  subject { described_class.new }

  context 'with a project sent yesterday' do
    let!(:project) { create(:project, :submitted, submitted_to_pol: 1.day.ago) }

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
