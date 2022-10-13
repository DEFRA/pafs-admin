# frozen_string_literal: true

describe ProjectsSentToPol::Report::Failure do
  subject(:report_failure) { described_class.new }

  context "with a project that failed to send to pol" do
    let!(:project) { create(:project, :submitted, submitted_to_pol: nil) }

    it "returns false for #empty" do
      expect(report_failure).not_to be_empty
    end

    it "returns 1 for size" do
      expect(report_failure.size).to be(1)
    end
  end

  context "with a project sent two days ago" do
    let!(:project) { create(:project, :submitted, submitted_to_pol: 2.days.ago) }

    it "returns true for #empty" do
      expect(report_failure).to be_empty
    end

    it "returns 0 for size" do
      expect(report_failure.size).to be(0)
    end
  end
end
