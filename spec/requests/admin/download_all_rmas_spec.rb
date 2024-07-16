# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Organisations" do

  describe "GET admin/download_all_rmas.xls" do
    let(:admin) { create(:back_office_user, :rma, admin: true) }
    let(:rma_organisations) { create_list(:organisation, 5, :rma) }

    before do
      sign_in(admin)
      rma_organisations
      get admin_download_all_rmas_path(format: :xls)
    end

    context "when format is XLS" do
      let(:first) { rma_organisations.min_by(&:name) }

      it "sends an XLS file" do
        expect(response.header["Content-Type"]).to include "application/vnd.ms-excel"
        expect(response.header["Content-Disposition"]).to include 'filename="all_rma.xls"'
      end

      it "contains valid headers" do
        expect(response.body).to include("Identifier", "Type", "Name", "Code", "PSO Team", "Area", "End Date")
      end

      it "contains valid data" do
        aggregate_failures do
          expect(response.body).to match(/#{first.name}/)
          expect(response.body).to match(/#{first.identifier}/)
          expect(response.body).to match(/#{first.sub_type}/)
          expect(response.body).to match(/#{Organisation.authorities.find_by(identifier: first.sub_type).name}/)
          expect(response.body).to match(/#{first.parent.name}/)
          expect(response.body).to match(/#{PafsCore::RFCC_CODE_NAMES_MAP[first.parent.sub_type]}/)
          expect(response.body).to match(/#{first.end_date}/)
        end
      end
    end

  end
end
