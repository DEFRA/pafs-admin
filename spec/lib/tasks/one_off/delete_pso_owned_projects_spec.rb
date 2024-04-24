# frozen_string_literal: true

require "rails_helper"

module OneOff
  RSpec.describe "delete_pso_owned_projects", type: :rake do

    describe "one_off:delete_pso_owned_projects", type: :rake do
      let(:task) { Rake::Task["one_off:delete_pso_owned_projects"] }

      let(:rma_area) { create(:rma_area) }
      let(:rma_project) { create(:project) }
      let(:pso_area) { create(:pso_area) }
      let(:pso_project) { create(:project) }

      before do
        rma_project.area_projects.create(area_id: rma_area.id, owner: true)
        pso_project.area_projects.create(area_id: pso_area.id, owner: true)

        task.reenable
      end

      it { expect { task.invoke }.not_to raise_error }

      it { expect { task.invoke }.to change { PafsCore::Project.where(id: pso_project.id).count }.to(0) }

      it { expect { task.invoke }.not_to change { PafsCore::Project.where(id: rma_project.id).count }.from(1) }
    end
  end
end
