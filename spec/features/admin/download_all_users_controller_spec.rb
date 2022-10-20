# frozen_string_literal: true

RSpec.describe Admin::DownloadAllUsersController, type: :controller do
  let!(:user) { create(:admin, :pso) }

  context "when a user downloads an xls file of all the users" do

    it "returns the correct file type" do
      get :show, format: :xls
      expect(response.headers["Content-Type"]).to eq("application/vnd.ms-excel")
    end

    it "returns the correct column headers" do
      get :show, format: :xls

      spreadsheet = Spreadsheet.open(StringIO.new(response.body))
      worksheet = spreadsheet.worksheet(0)

      expect(worksheet.row(0)[0]).to eq("admin")
      expect(worksheet.row(0)[1]).to eq("email")
      expect(worksheet.row(0)[2]).to eq("first_name")
      expect(worksheet.row(0)[3]).to eq("id")
      expect(worksheet.row(0)[4]).to eq("last_name")
      expect(worksheet.row(0)[5]).to eq("last_sign_in_at")
    end

    it "returns the correct user details" do
      get :show, format: :xls

      spreadsheet = Spreadsheet.open(StringIO.new(response.body))
      worksheet = spreadsheet.worksheet(0)

      expect(worksheet.row(1)[0]).to be(true)
      expect(worksheet.row(1)[1]).to eq("admin@example.com")
      expect(worksheet.row(1)[2]).to eq("Admin")
      expect(worksheet.row(1)[4]).to eq("User")
      expect(worksheet.row(1)[5]).to be_nil
    end

  end
end
