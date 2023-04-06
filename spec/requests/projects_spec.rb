# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects" do

  let(:admin) { create(:back_office_user, :rma, admin: true) }
  let(:user) { create(:back_office_user, :rma, admin: false) }
  let(:rma_area) { create(:rma_area) }
  let(:rma_project) { create(:project, creator: user, state: create(:state, state: :draft)) }

  before do
    create_list(:rma_area, 5)
    user.user_areas.create(area_id: rma_area.id, primary: true)
    rma_project.area_projects.create(area_id: rma_area.id, owner: true)
  end

  describe "GET admin/projects" do

    context "when logged in as a non-admin user" do
      before do
        sign_in(user)
        get admin_projects_path
      end

      it "does not render the projects table" do
        assert_select "table", 0
      end
    end

    context "when logged in as an admin user" do
      before do
        sign_in(admin)
      end

      it "renders the projects table" do
        get admin_projects_path

        assert_select "table", 1
      end

      it "includes the first project's number" do
        get admin_projects_path

        expect(response.body).to match(/#{rma_project.reference_number}/)
      end
    end
  end

  describe "GET edit" do
    before do
      sign_in(admin)
    end

    shared_examples "RMA dropdown list" do
      it "includes the dropdown" do
        assert_select "select", 1
      end

      it "includes options for each of the RMA areas" do
        assert_select "option", PafsCore::Area.rma_areas.length
      end
    end

    context "with an RMA-owned project" do
      before { get edit_admin_project_path(rma_project.reference_number) }

      it "shows the current owning area name" do
        expect(response.body).to match(/Current RMA.{5,20}#{rma_project.owner.name}/m)
      end

      it_behaves_like "RMA dropdown list"

      it "shows the current RMA by default" do
        assert_select "select" do |elements|
          expect(elements[0].search('option[@selected="selected"]')[0].attr("value").to_i).to eq rma_project.owner.id
        end
      end
    end

    # support for existing PSO-owned areas is required until https://eaflood.atlassian.net/browse/RUBY-2432 has been implemented
    context "with a PSO-owned project" do
      let(:pso_user) { create(:back_office_user, :pso) }
      let(:pso_project) { create(:project, creator: pso_user, state: create(:state, state: :draft)) }

      before do
        pso_project.area_projects.create(area_id: create(:pso_area).id, owner: true)
        get edit_admin_project_path(pso_project.reference_number)
      end

      it "shows the current owning area name" do
        expect(response.body).to match(/Current RMA.{5,20}#{pso_project.owner.name}/m)
      end

      it_behaves_like "RMA dropdown list"

      it "does not show the current owning area by default" do
        assert_select "select" do |elements|
          expect(elements[0].search('option[@selected="selected"]')).to be_empty
        end
      end
    end
  end

  describe "PATCH save" do
    subject(:submit_change_rma) { patch save_admin_project_path(rma_project.reference_number, rma_id: new_rma_area_id) }

    before { sign_in admin }

    context "with an invalid RMA id" do
      let(:new_rma_area_id) { "foo" }

      it "raises an error" do
        expect { submit_change_rma }.not_to change(rma_project, :owner)
      end
    end

    context "with no change to the RMA" do
      let(:new_rma_area_id) { rma_area.id }

      it "does not update the project owner" do
        expect { submit_change_rma }.not_to change(rma_project, :owner)
      end
    end

    context "with a valid RMA" do
      let(:new_rma_area) { create(:rma_area) }
      let(:new_rma_area_id) { new_rma_area.id }

      it "updates the project owner" do
        expect { submit_change_rma }.to change(rma_project, :owner).to(new_rma_area)
      end

      it "updates the project's rma_name" do
        expect { submit_change_rma }.to change { rma_project.reload.rma_name }.to(new_rma_area.name)
      end

      it "redirects to the view all projects page" do
        submit_change_rma
        expect(response).to redirect_to admin_projects_path
      end
    end
  end
end
