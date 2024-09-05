# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::DownloadAllUsersController, type: :controller do
  let!(:user) { create(:back_office_user, :pso) }

  context "when a user downloads an xls file of all the users" do
    let(:worksheet) do
      get :show, format: :xls
      spreadsheet = Spreadsheet.open(StringIO.new(response.body))
      spreadsheet.worksheet(0)
    end

    it "returns the correct file type" do
      get :show, format: :xls
      expect(response.headers["Content-Type"]).to eq("application/vnd.ms-excel")
    end

    describe "column headers" do
      it "returns the correct user details headers" do
        expect(worksheet.row(0)[0]).to eq("Id")
        expect(worksheet.row(0)[1]).to eq("Email")
        expect(worksheet.row(0)[2]).to eq("Last Name")
        expect(worksheet.row(0)[3]).to eq("First Name")
        expect(worksheet.row(0)[8]).to eq("Admininstrator?")
      end

      it "returns the correct user areas headers" do
        expect(worksheet.row(0)[4]).to eq("Main Area")
        expect(worksheet.row(0)[5]).to eq("1st Area")
        expect(worksheet.row(0)[6]).to eq("2nd Area")
        expect(worksheet.row(0)[7]).to eq("3rd Area")
      end

      it "returns the correct invitation and sign in headers" do
        expect(worksheet.row(0)[9]).to eq("Invitation sent")
        expect(worksheet.row(0)[10]).to eq("Invitation accepted")
        expect(worksheet.row(0)[11]).to eq("Last sign in")
      end
    end

    describe "user details" do
      it "returns the correct user details" do
        expect(worksheet.row(1)[0]).to eq(user.id)
        expect(worksheet.row(1)[1]).to eq(user.email)
        expect(worksheet.row(1)[2]).to eq(user.last_name)
        expect(worksheet.row(1)[3]).to eq(user.first_name)
        expect(worksheet.row(1)[8]).to eq(user.admin ? "Yes" : "No")
      end

      it "returns the correct user areas" do
        expect(worksheet.row(1)[4]).to eq(user.areas.first.name)
        expect(worksheet.row(1)[5]).to eq(user.areas.second&.name)
        expect(worksheet.row(1)[6]).to eq(user.areas.third&.name)
        expect(worksheet.row(1)[7]).to eq(user.areas.fourth&.name)
      end

      it "returns the correct invitation and sign in dates" do
        expect(worksheet.row(1)[9]).to eq(user.invitation_sent_at&.strftime("%Y.%m.%d"))
        expect(worksheet.row(1)[10]).to eq(user.invitation_accepted_at&.strftime("%Y.%m.%d"))
        expect(worksheet.row(1)[11]).to eq(user.last_sign_in_at&.strftime("%Y.%m.%d"))
      end
    end
  end
end
