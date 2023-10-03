# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Organisations" do

  describe "GET admin/organisations" do
    let(:admin) { create(:back_office_user, :rma, admin: true) }
    let(:rma_organisations) { create_list(:organisation, 25, :rma) }
    let(:pso_organisations) { create_list(:organisation, 5, :pso) }
    let(:ea_organisations) { create_list(:organisation, 5, :ea) }

    before do
      sign_in(admin)
      rma_organisations
      pso_organisations
      ea_organisations
    end

    context "when no query or type is provided" do
      before { get admin_organisations_path }

      it "renders the organisations table" do
        assert_select "table", 1
      end

      it "includes the first organisation's name" do
        first_organisation = rma_organisations.min_by(&:name)
        expect(response.body).to match(/#{first_organisation.name}/)
      end

      it "shows organisations count (paginated)" do
        count = Organisation.where(area_type: Organisation::RMA_AREA).count
        expect(response.body).to match(%r{Showing <b>1&nbsp;-&nbsp;20</b> of <b>#{count}</b> organisations})
      end
    end

    context "when a query is provided" do
      before { get admin_organisations_path(q: rma_organisations.first.name) }

      it "renders the organisations table" do
        assert_select "table", 1
      end

      it "includes the first organisation's name" do
        first_organisation = rma_organisations.first
        expect(response.body).to match(/#{first_organisation.name}/)
      end

      it "shows organisations count" do
        expect(response.body).to match(%r{Displaying <b>1</b> organisation})
      end
    end

    context "when a type is provided" do
      before { get admin_organisations_path(type: Organisation::PSO_AREA) }

      it "renders the organisations table" do
        assert_select "table", 1
      end

      it "includes the first organisation's name" do
        first_organisation = pso_organisations.min_by(&:name)
        expect(response.body).to match(/#{first_organisation.name}/)
      end

      it "shows organisations count" do
        expect(response.body).to match(%r{Displaying <b>all #{pso_organisations.count + 1}</b> organisations})
      end
    end

    context "when an invalid type is provided" do
      before { get admin_organisations_path(type: "invalid_type") }

      it "sets a flash notice" do
        expect(flash[:notice]).to eq("Invalid organisation type: invalid_type")
      end
    end

  end

  describe "GET new - without type selected" do
    let(:admin) { create(:back_office_user, :rma, admin: true) }

    before do
      sign_in(admin)
    end

    context "when editing an RMA" do
      before { get new_admin_organisation_path }

      it "has correct page title" do
        assert_select "h1", "Add a new organisation"
      end

      it "includes Select an organisation type dropdown" do
        assert_select "select[name='type']", 1
      end

      it "includes submit button" do
        assert_select "button[type='submit']", 1
      end
    end
  end

  shared_examples "organisation form" do
    it "includes name field" do
      assert_select "input[name='organisation[name]']", 1
    end

    it "includes end_date field" do
      assert_select "input[name='organisation[end_date]']", 1
    end

    it "includes submit button" do
      assert_select "button[type='submit']", 1
    end
  end

  describe "GET new - with type selected" do
    let(:admin) { create(:back_office_user, :rma, admin: true) }

    before do
      sign_in(admin)
    end

    context "when adding an RMA" do
      before { get new_admin_organisation_path(type: "RMA") }

      it_behaves_like "organisation form"

      it "has correct page title" do
        assert_select "h1", "Add a RMA"
      end

      it "includes identifier code field" do
        assert_select "input[name='organisation[identifier]']", 1
      end

      it "includes sub_type dropdown" do
        assert_select "select[name='organisation[sub_type]']", 1
      end

      it "includes associated PSO dropdown" do
        assert_select "select[name='organisation[parent_id]']", 1
      end
    end

    context "when adding an Authority" do
      before { get new_admin_organisation_path(type: "Authority") }

      it_behaves_like "organisation form"

      it "has correct page title" do
        assert_select "h1", "Add an Authority Code"
      end

      it "includes identifier code field" do
        assert_select "input[name='organisation[identifier]']", 1
      end
    end

    context "when adding an PSO" do
      before { get new_admin_organisation_path(type: "PSO Area") }

      it_behaves_like "organisation form"

      it "has correct page title" do
        assert_select "h1", "Add a PSO"
      end

      it "includes associated PSO dropdown" do
        assert_select "select[name='organisation[parent_id]']", 1
      end
    end
  end

  describe "GET edit" do
    let(:admin) { create(:back_office_user, :rma, admin: true) }
    let(:rma) { create(:organisation, :rma) }
    let(:authority) { create(:organisation, :authority) }
    let(:pso) { create(:organisation, :pso) }

    before do
      sign_in(admin)
    end

    context "when editing an RMA" do
      before do
        rma
        get edit_admin_organisation_path(rma)
      end

      it_behaves_like "organisation form"

      it "has correct page title" do
        assert_select "h1", "Edit a RMA"
      end

      it "includes identifier code field" do
        assert_select "input[name='organisation[identifier]']", 1
      end

      it "includes sub_type dropdown" do
        assert_select "select[name='organisation[sub_type]']", 1
      end

      it "shows the current sub_type by default" do
        assert_select "select[name='organisation[sub_type]']" do |elements|
          expect(elements[0].search('option[@selected="selected"]')[0].attr("value").to_s).to eq rma.sub_type
        end
      end

      it "includes associated PSO dropdown" do
        assert_select "select[name='organisation[parent_id]']", 1
      end

      it "shows the current associated PSO by default" do
        assert_select "select[name='organisation[parent_id]']" do |elements|
          expect(elements[0].search('option[@selected="selected"]')[0].attr("value").to_i).to eq rma.parent_id
        end
      end
    end

    context "when editing an Authority" do
      before do
        authority
        get edit_admin_organisation_path(authority)
      end

      it_behaves_like "organisation form"

      it "has correct page title" do
        assert_select "h1", "Edit an Authority Code"
      end

      it "includes identifier code field" do
        assert_select "input[name='organisation[identifier]']", 1
      end
    end

    context "when editing an PSO" do
      before do
        pso
        get edit_admin_organisation_path(pso)
      end

      it_behaves_like "organisation form"

      it "has correct page title" do
        assert_select "h1", "Edit a PSO"
      end

      it "includes associated PSO dropdown" do
        assert_select "select[name='organisation[parent_id]']", 1
      end

      it "shows the current associated PSO by default" do
        assert_select "select[name='organisation[parent_id]']" do |elements|
          expect(elements[0].search('option[@selected="selected"]')[0].attr("value").to_i).to eq pso.parent_id
        end
      end
    end
  end

  describe "PATCH create RMA" do
    subject(:submit_create_form) { post admin_organisations_path(organisation: organisation_params) }

    let(:organisation_params) { { area_type: "RMA", name: "Test Org Name", identifier: "T987", sub_type: "IDC", parent_id: 999, end_date: "2026-10-01" } }
    let(:admin) { create(:back_office_user, :rma, admin: true) }

    before { sign_in admin }

    context "with invalid details" do
      it "shows an error when organisation name is not passed" do
        organisation_params[:name] = nil
        submit_create_form
        expect(response.body).to match(/organisation-name-field-error/)
      end

      it "shows an error when identifier is not passed" do
        organisation_params[:identifier] = nil
        submit_create_form
        expect(response.body).to match(/organisation-identifier-field-error/)
      end

      it "shows an error when sub_type is not passed" do
        organisation_params[:sub_type] = nil
        submit_create_form
        expect(response.body).to match(/organisation-sub-type-field-error/)
      end

      it "shows an error when parent_id is not passed" do
        organisation_params[:parent_id] = nil
        submit_create_form
        expect(response.body).to match(/organisation-parent-id-field-error/)
      end
    end

    context "with valid details" do
      it "Creates organisation record" do
        submit_create_form

        rma = Organisation.last
        expect(rma.area_type).to eq("RMA")
        expect(rma.name).to eq("Test Org Name")
        expect(rma.identifier).to eq("T987")
        expect(rma.sub_type).to eq("IDC")
        expect(rma.parent_id).to eq(999)
        expect(rma.end_date.to_s).to eq("2026-10-01")
      end

      it "redirects to the view all organisations page" do
        submit_create_form

        expect(response).to redirect_to admin_organisations_path(type: "RMA")
      end
    end
  end

  describe "PATCH create Authority" do
    subject(:submit_create_form) { post admin_organisations_path(organisation: organisation_params) }

    let(:organisation_params) { { area_type: "Authority", name: "Test Authority", identifier: "T987", end_date: "2026-10-01" } }
    let(:admin) { create(:back_office_user, :rma, admin: true) }

    before { sign_in admin }

    context "with invalid details" do
      it "shows an error when organisation name is not passed" do
        organisation_params[:name] = nil
        submit_create_form
        expect(response.body).to match(/organisation-name-field-error/)
      end

      it "shows an error when identifier is not passed" do
        organisation_params[:identifier] = nil
        submit_create_form
        expect(response.body).to match(/organisation-identifier-field-error/)
      end
    end

    context "with valid details" do
      it "Creates organisation record" do
        submit_create_form

        rma = Organisation.last
        expect(rma.area_type).to eq("Authority")
        expect(rma.name).to eq("Test Authority")
        expect(rma.identifier).to eq("T987")
        expect(rma.end_date.to_s).to eq("2026-10-01")
      end

      it "redirects to the view all organisations page" do
        submit_create_form

        expect(response).to redirect_to admin_organisations_path(type: "Authority")
      end
    end
  end

  describe "PATCH create PSO" do
    subject(:submit_create_form) { post admin_organisations_path(organisation: organisation_params) }

    let(:organisation_params) { { area_type: "PSO Area", name: "Test PSO Area", parent_id: 999, sub_type: "TH", end_date: "2026-10-01" } }
    let(:admin) { create(:back_office_user, :rma, admin: true) }

    before { sign_in admin }

    context "with invalid details" do
      it "shows an error when organisation name is not passed" do
        organisation_params[:name] = nil
        submit_create_form
        expect(response.body).to match(/organisation-name-field-error/)
      end

      it "shows an error when parent_id is not passed" do
        organisation_params[:parent_id] = nil
        submit_create_form
        expect(response.body).to match(/organisation-parent-id-field-error/)
      end

      it "shows an error when sub_type is not passed" do
        organisation_params[:sub_type] = nil
        submit_create_form
        expect(response.body).to match(/organisation-sub-type-field-error/)
      end
    end

    context "with valid details" do
      it "Creates organisation record" do
        submit_create_form

        rma = Organisation.last
        expect(rma.area_type).to eq("PSO Area")
        expect(rma.name).to eq("Test PSO Area")
        expect(rma.parent_id).to eq(999)
        expect(rma.end_date.to_s).to eq("2026-10-01")
      end

      it "redirects to the view all organisations page" do
        submit_create_form

        expect(response).to redirect_to admin_organisations_path(type: "PSO Area")
      end
    end
  end

  describe "PATCH update RMA" do
    let(:admin) { create(:back_office_user, :rma, admin: true) }
    let(:rma) { create(:organisation, :rma) }

    before { sign_in admin }

    context "with invalid details" do
      subject(:submit_change_form) { patch admin_organisation_path(rma, organisation: organisation_params) }

      let(:organisation_params) { { area_type: "RMA", name: "Test Org Name", identifier: "T987", sub_type: "IDC", parent_id: 999, end_date: "2026-10-01" } }

      it "shows an error when organisation name is not passed" do
        organisation_params[:name] = nil
        submit_change_form
        expect(response.body).to match(/organisation-name-field-error/)
      end

      it "shows an error when identifier is not passed" do
        organisation_params[:identifier] = nil
        submit_change_form
        expect(response.body).to match(/organisation-identifier-field-error/)
      end

      it "shows an error when sub_type is not passed" do
        organisation_params[:sub_type] = nil
        submit_change_form
        expect(response.body).to match(/organisation-sub-type-field-error/)
      end

      it "shows an error when parent_id is not passed" do
        organisation_params[:parent_id] = nil
        submit_change_form
        expect(response.body).to match(/organisation-parent-id-field-error/)
      end
    end

    context "with valid details" do
      it "updates the organisation's name" do
        expect do
          patch admin_organisation_path(rma, organisation: { name: "Test Org Name" })
        end.to change { rma.reload.name }.to("Test Org Name")
      end

      it "updates the organisation's identifier" do
        expect do
          patch admin_organisation_path(rma, organisation: { identifier: "T987" })
        end.to change { rma.reload.identifier }.to("T987")
      end

      it "updates the organisation's authority code" do
        expect do
          patch admin_organisation_path(rma, organisation: { sub_type: "IDC" })
        end.to change { rma.reload.sub_type }.to("IDC")
      end

      it "updates the organisation's associated PSO" do
        expect do
          patch admin_organisation_path(rma, organisation: { parent_id: 999 })
        end.to change { rma.reload.parent_id }.to(999)
      end

      it "updates the organisation's end date" do
        expect do
          patch admin_organisation_path(rma, organisation: { end_date: "2026-10-01" })
        end.to change { rma.reload.end_date.to_s }.to("2026-10-01")
      end

      it "redirects to the view all organisations page" do
        patch admin_organisation_path(rma, organisation: { name: "test" })

        expect(response).to redirect_to admin_organisations_path(type: "RMA")
      end
    end
  end

  describe "PATCH update Authority" do
    let(:admin) { create(:back_office_user, :rma, admin: true) }
    let(:authority) { create(:organisation, :authority) }

    before { sign_in admin }

    context "with invalid details" do
      subject(:submit_change_form) { patch admin_organisation_path(authority, organisation: organisation_params) }

      let(:organisation_params) { { area_type: "Authority", name: "Test Authority", identifier: "T987", end_date: "2026-10-01" } }

      it "shows an error when organisation name is not passed" do
        organisation_params[:name] = nil
        submit_change_form
        expect(response.body).to match(/organisation-name-field-error/)
      end

      it "shows an error when identifier is not passed" do
        organisation_params[:identifier] = nil
        submit_change_form
        expect(response.body).to match(/organisation-identifier-field-error/)
      end
    end

    context "with valid details" do
      it "updates the organisation's name" do
        expect do
          patch admin_organisation_path(authority, organisation: { name: "Test Org Name" })
        end.to change { authority.reload.name }.to("Test Org Name")
      end

      it "updates the organisation's identifier" do
        expect do
          patch admin_organisation_path(authority, organisation: { identifier: "T987" })
        end.to change { authority.reload.identifier }.to("T987")
      end

      it "updates the organisation's end date" do
        expect do
          patch admin_organisation_path(authority, organisation: { end_date: "2026-10-01" })
        end.to change { authority.reload.end_date.to_s }.to("2026-10-01")
      end

      it "redirects to the view all organisations page" do
        patch admin_organisation_path(authority, organisation: { name: "test" })

        expect(response).to redirect_to admin_organisations_path(type: "Authority")
      end
    end
  end

  describe "PATCH update PSO" do
    let(:admin) { create(:back_office_user, :rma, admin: true) }
    let(:pso) { create(:organisation, :pso) }

    before { sign_in admin }

    context "with invalid details" do
      subject(:submit_change_form) { patch admin_organisation_path(pso, organisation: organisation_params) }

      let(:organisation_params) { { area_type: "PSO Area", name: "Test PSO Area", parent_id: 999, sub_type: "TH", end_date: "2026-10-01" } }

      it "shows an error when organisation name is not passed" do
        organisation_params[:name] = nil
        submit_change_form
        expect(response.body).to match(/organisation-name-field-error/)
      end

      it "shows an error when parent_id is not passed" do
        organisation_params[:parent_id] = nil
        submit_change_form
        expect(response.body).to match(/organisation-parent-id-field-error/)
      end

      it "shows an error when sub_type is not passed" do
        organisation_params[:sub_type] = nil
        submit_change_form
        expect(response.body).to match(/organisation-sub-type-field-error/)
      end
    end

    context "with valid details" do
      it "updates the organisation's name" do
        expect do
          patch admin_organisation_path(pso, organisation: { name: "Test Org Name" })
        end.to change { pso.reload.name }.to("Test Org Name")
      end

      it "updates the organisation's associated EA Area" do
        expect do
          patch admin_organisation_path(pso, organisation: { parent_id: 999 })
        end.to change { pso.reload.parent_id }.to(999)
      end

      it "updates the organisation's end date" do
        expect do
          patch admin_organisation_path(pso, organisation: { end_date: "2026-10-01" })
        end.to change { pso.reload.end_date.to_s }.to("2026-10-01")
      end

      it "redirects to the view all organisations page" do
        patch admin_organisation_path(pso, organisation: { name: "test" })

        expect(response).to redirect_to admin_organisations_path(type: "PSO Area")
      end
    end
  end
end
