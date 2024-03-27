# frozen_string_literal: true

require "rails_helper"

Rails.application.load_tasks

RSpec.describe "OneOff", type: :rake do
  describe "one_off:reset_expired_project_end_financial_years", type: :rake do
    let(:task) { Rake::Task["one_off:reset_expired_project_end_financial_years"] }

    let(:state) { create(:state, state: "draft") }
    let(:expired_project) { create(:project, state: state, project_end_financial_year: 2022) }
    let(:not_expired_project) { create(:project, state: state, project_end_financial_year: 2032) }

    before do
      task.reenable
    end

    it "runs without error" do
      expect { task.invoke }.not_to raise_error
    end

    context "when there are expired and non-expired projects" do
      it "sets project_end_financial_year to nil for expired project" do
        expect(expired_project.project_end_financial_year).to be_positive
        task.invoke
        expect(expired_project.reload.project_end_financial_year).to be_nil
      end

      it "doesn't modify the project with not expired project end FY" do
        expect { task.invoke }.not_to change(not_expired_project, :project_end_financial_year)
      end
    end
  end
end
