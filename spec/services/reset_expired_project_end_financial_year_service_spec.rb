# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResetExpiredProjectEndFinancialYearService do

  include PafsCore::FinancialYear

  subject(:service) { described_class }

  let!(:project) { create(:project, state: state) }
  let(:state) { create(:state, state: "draft") }

  describe "#run" do
    shared_examples "resets project_end_financial_year" do
      it "sets project_end_financial_year to nil" do
        service.run

        expect(project.reload.project_end_financial_year).to eq(current_financial_year)
      end
    end

    context "when project end FY is expired" do
      before do
        project.update(project_end_financial_year: 2022)
      end

      it_behaves_like "resets project_end_financial_year"
    end

    context "when project end FY is not expired" do
      before do
        project.update(project_end_financial_year: 2032)
      end

      it "does not modify the project" do
        expect { service.run }.not_to change(project, :project_end_financial_year)
      end
    end
  end
end
