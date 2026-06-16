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
      let(:worksheet) { Spreadsheet.open(StringIO.new(response.body)).worksheet(0) }
      let(:data_row) do
        (1...worksheet.row_count)
          .map { |index| worksheet.row(index) }
          .find { |row| row[0] == first.identifier }
      end

      it "sends an XLS file" do
        expect(response.header["Content-Type"]).to include "application/vnd.ms-excel"
        expect(response.header["Content-Disposition"]).to include 'filename="all_rma.xls"'
      end

      it "contains valid headers" do
        expect(worksheet.row(0)).to eq(["Identifier", "Type", "Name", "Code", "PSO Team", "Area", "End Date"])
      end

      it "contains valid data" do
        aggregate_failures do
          expect(data_row[0]).to eq(first.identifier)
          expect(data_row[1]).to eq(Organisation.authorities.find_by(identifier: first.sub_type).name)
          expect(data_row[2]).to eq(first.name)
          expect(data_row[3]).to eq(first.sub_type)
          expect(data_row[4]).to eq(first.parent.name)
          expect(data_row[5]).to eq(PafsCore::RFCC_CODE_NAMES_MAP[first.parent.sub_type])
          expect(data_row[6]).to eq(first.end_date)
        end
      end
    end

  end
end
