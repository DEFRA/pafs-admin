# frozen_string_literal: true

describe ProjectsSentToPol::Report::Success do
  subject(:report_success) { described_class.new }

  context "with a project sent yesterday" do
    let!(:project) { create(:project, :submitted, submitted_to_pol: 1.day.ago) }

    it "returns false for #empty" do
      expect(report_success).not_to be_empty
    end

    it "returns 1 for size" do
      expect(report_success.size).to be(1)
    end
  end

  context "with a project sent two days ago" do
    let!(:project) { create(:project, :submitted, submitted_to_pol: 2.days.ago) }

    it "returns true for #empty" do
      expect(report_success).to be_empty
    end

    it "returns 0 for size" do
      expect(report_success.size).to be(0)
    end
  end
end
