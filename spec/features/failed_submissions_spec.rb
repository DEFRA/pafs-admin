# frozen_string_literal: true

RSpec.describe "Failed to Send Report" do
  let(:user) { create(:back_office_user, :pso) }

  around do |example|
    ClimateControl.modify(
      POL_SUBMISSION_URL: "https://example.com/submit",
      AZURE_VAULT_AUTH_TOKEN_KEY_NAME_SUBMISSION: "KEY_NAME"
    ) do
      example.run
    end
  end

  before do
    allow(PafsCore::Pol::AzureVaultClient).to receive(:fetch).with("KEY_NAME").and_return("APITOKEN")
    stub_request(:post, "https://example.com/submit").to_return(status: 200)

    login_as(user)
  end

  context "with a successfully submitted project" do
    let!(:project) { create(:project, :submitted_to_pol, creator: user) }

    it "listing failed submissions" do
      visit "/"
      click_on "Failed Submissions"
      expect(page).to have_content("There are no failed submissions")
    end
  end

  context "with a failed submission" do
    let!(:project) { create(:full_project, :with_no_shapefile, :submission_failed, creator: user) }

    it "listing the failed projects" do
      visit "/"
      click_on "Failed Submissions"

      expect(page).not_to have_content("There are no failed submissions")
      expect(page).to have_content(project.reference_number)
    end

    it "setting the project as submitted" do
      visit "/"
      click_on "Failed Submissions"

      expect do
        click_on "Proposal in PoL"
        expect(page).to have_content("There are no failed submissions")
      end.to change { project.reload.submitted_to_pol }
    end

    it "resubmitting the project" do
      visit "/"
      click_on "Failed Submissions"

      expect do
        click_on "Resend to PoL"
        expect(page).to have_content("There are no failed submissions")
      end.to change { project.reload.submitted_to_pol }
    end
  end
end
