# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects" do

  let(:admin) { create(:back_office_user, :pso, admin: true) }
  let(:user) { create(:back_office_user, :pso, admin: false) }
  let(:area1) { PafsCore::Area.first }
  let(:area2) { PafsCore::Area.last }
  let(:project1) { create(:project, state: create(:state, state: "draft")) }
  let(:project2) { create(:project, state: create(:state, state: "draft")) }

  before do
    user.user_areas.create(area_id: area1.id, primary: true)
    project1.area_projects.create(area_id: area1.id)
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

        expect(response.body).to match(/#{project1.reference_number}/)
      end
    end
  end

  describe "GET edit" do
    before do
      sign_in(admin)
      get edit_admin_project_path(project1.id)
    end

    it "renders the project edit view" do
      byebug
      assert_select "summat"
    end
  end

  describe "PATCH save" do

    subject(:submit_change_rma) { patch :save, params: { id: project.to_param, rma: new_rma } }

    context "with an invalid RMA" do
      let(:new_rma) { nil }

      it "does not update the project" do
        expect { submit_change_rma }.not_to change { project.creator.primary_area }
      end

      it "displays an error" do
        submit_change_rma
        expect(response).to include_something
      end
    end

    context "with no change to the RMA" do
      let(:new_rma) { old_rma }

      it "does not update the project" do
        expect { submit_change_rma }.not_to change { project.creator.primary_area }
      end

      it "displays an error" do
        submit_change_rma
        expect(response).to something
      end
    end

    context "with a valid RMA" do
      let(:new_rma) { create(:rma_area) }

      it "updates the project" do
        expect { submit_change_rma }.to change(project, rma).to(new_rma)
      end

      it "redirects to the view all projects page" do
        submit_change_rma
        expect(response).to redirect_to admin_projects_path
      end
    end
  end
end
