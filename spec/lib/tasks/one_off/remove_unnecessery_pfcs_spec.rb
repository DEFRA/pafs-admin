# frozen_string_literal: true

require "rails_helper"

RSpec.describe "OneOff", type: :rake do

  describe "one_off:remove_unnecessery_pfcs", type: :rake do
    let(:task) { Rake::Task["one_off:remove_unnecessery_pfcs"] }

    let(:state) { create(:state, state: "draft") }
    let(:project_type) { "DEF" }
    let(:calculator_file) { "v8.xlsx" }
    let(:project) { create(:project, funding_calculator_file_name: calculator_file, state: state, project_type: project_type) }
    let(:storage) { instance_double(PafsCore::DevelopmentFileStorageService) }

    before do
      task.reenable
    end

    shared_examples "does not remove PFC file" do
      it "runs without error" do
        expect { task.invoke }.not_to raise_error
      end

      it "does not remove PFC file" do
        expect { task.invoke }.not_to change { project.reload.funding_calculator_file_name }
      end
    end

    shared_examples "removes PFC file" do
      it "runs without error" do
        expect { task.invoke }.not_to raise_error
      end

      it "removes PFC file" do
        allow(PafsCore::DevelopmentFileStorageService).to receive(:new).and_return(storage)
        allow(storage).to receive(:delete).and_return(true)
        expect { task.invoke }.to change { project.reload.funding_calculator_file_name }.from(calculator_file).to(nil)
      end
    end

    context "when project state is draft or archived" do
      let(:state) { create(:state, state: "draft") }

      context "when project type is DEF or CM" do
        let(:project_type) { "DEF" }

        it_behaves_like "does not remove PFC file"
      end

      context "when project type is not DEF or CM" do
        let(:project_type) { "STR" }

        it_behaves_like "removes PFC file"
      end
    end

    context "when project state is not draft or archived" do
      let(:state) { create(:state, state: "submitted") }

      context "when project type is DEF or CM" do
        let(:project_type) { "DEF" }

        it_behaves_like "does not remove PFC file"
      end

      context "when project type is not DEF or CM" do
        let(:project_type) { "STR" }

        it_behaves_like "does not remove PFC file"
      end
    end
  end
end
