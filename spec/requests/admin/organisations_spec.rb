# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Organisations" do

  let(:admin) { create(:back_office_user, :rma, admin: true) }
  let(:rma_organisations) { create_list(:organisation, 25, :rma) }
  let(:authority_organisations) { create_list(:organisation, 5, :authority) }
  let(:pso_organisations) { create_list(:organisation, 5, :pso) }

  before do
    sign_in(admin)
    rma_organisations
    authority_organisations
    pso_organisations
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
      expect(response.body).to match(%r{Showing <b>1&nbsp;-&nbsp;20</b> of <b>#{rma_organisations.count}</b> organisations})
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
    before { get admin_organisations_path(type: PafsCore::Organisation::PSO) }

    it "renders the organisations table" do
      assert_select "table", 1
    end

    it "includes the first organisation's name" do
      first_organisation = pso_organisations.min_by(&:name)
      expect(response.body).to match(/#{first_organisation.name}/)
    end

    it "shows organisations count" do
      expect(response.body).to match(%r{Displaying <b>all #{pso_organisations.count}</b> organisations})
    end
  end

  context "when an invalid type is provided" do
    before { get admin_organisations_path(type: "invalid_type") }

    it "sets a flash notice" do
      expect(flash[:notice]).to eq("Invalid organisation type: invalid_type")
    end
  end
end
