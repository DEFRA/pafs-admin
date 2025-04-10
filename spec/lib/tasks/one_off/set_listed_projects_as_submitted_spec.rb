# frozen_string_literal: true

require "rails_helper"

RSpec.describe "OneOff", type: :rake do
  describe "one_off:set_listed_projects_as_submitted", type: :rake do
    let(:task) { Rake::Task["one_off:set_listed_projects_as_submitted"] }

    let(:state) { create(:state, state: project_state) }
    let(:project) { create(:project, reference_number: "SNC501E/000A/103A", state: state) }

    before do
      task.reenable
    end

    it "runs without error" do
      expect { task.invoke }.not_to raise_error
    end

    context "when the project is in the list" do
      context "when the project state is draft" do
        let(:project_state) { "draft" }

        it "sets project state to sumitted" do
          expect(project.state.state).to eq(project_state)
          task.invoke
          expect(project.reload.state.state).to eq("submitted")
        end
      end

      context "when the project state is completed" do
        let(:project_state) { "completed" }

        it "does not change project state to submitted" do
          expect(project.state.state).to eq(project_state)
          task.invoke
          expect(project.reload.state.state).to eq("completed")
        end
      end

      context "when the project state is archived" do
        let(:project_state) { "archived" }

        it "does not change project state to submitted" do
          expect(project.state.state).to eq(project_state)
          task.invoke
          expect(project.reload.state.state).to eq("archived")
        end
      end
    end

    context "when the project is not in the list" do
      let(:project_state) { "draft" }

      before do
        project.update(reference_number: "SNC501E/000A/999A")
      end

      it "does not change project state to submitted" do
        expect(project.state.state).to eq(project_state)
        task.invoke
        expect(project.reload.state.state).to eq("draft")
      end
    end
  end
end
