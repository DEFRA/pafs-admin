# frozen_string_literal: true

# rubocop:disable RSpecRails/HaveHttpStatus
RSpec.describe "Status update callback" do

  subject(:perform) do
    post "/admin/api/project/status", params: payload.to_json,
                                      headers: {
                                        Authorization: auth_token,
                                        "Content-Type": "application/json"
                                      }
  end

  let(:project) { create(:project, :submitted) }
  let(:status) { "Draft" }
  let(:payload) { { NPN: project.reference_number, Status: status } }
  let(:auth_token) { "Bearer VALID" }

  before do
    allow(ENV).to receive(:fetch).with("AZURE_VAULT_AUTH_TOKEN_KEY_NAME_RECEIVE").and_return("TOKEN_NAME")
    allow(PafsCore::Pol::AzureVaultClient).to receive(:fetch).with("TOKEN_NAME").and_return("VALID")
  end

  context "with an invalid auth token" do
    let(:auth_token) { "Bearer INVALID" }

    it "the project is not changed" do
      expect do
        perform
      end.not_to change { project.reload.status }
    end

    it "the endpoint responds with unauthorized" do
      perform
      expect(response.status).to be(401)
    end
  end

  context "with a valid auth token" do
    context "with a missing project" do
      let(:payload) { { NPN: "INVALID", Status: status } }

      it "the endpoint responds with a 404" do
        perform
        expect(response.status).to be(404)
      end
    end

    context "with an invalid payload" do
      let(:payload) { { NPN: project.reference_number, Status: "INVALID" } }

      it "the endpoint responds with a 422" do
        perform
        expect(response.status).to be(422)
      end

      it "no changes happen to the project" do
        expect { perform }.not_to change { project.reload.status }
      end
    end

    context "with a valid payload" do
      let(:remove_previous_years_service) { instance_double(PafsCore::RemovePreviousYearsService) }

      before do
        allow(PafsCore::RemovePreviousYearsService).to receive(:new).and_return(remove_previous_years_service)
        allow(remove_previous_years_service).to receive(:run)
      end

      it "the endpoint responds with a 204" do
        perform
        expect(response.status).to be(204)
      end

      it "the status of the project is set to draft" do
        expect { perform }.to change { project.reload.status }.to(:draft)
      end

      it "calls the RemovePreviousYears service" do
        perform
        expect(remove_previous_years_service).to have_received(:run)
      end
    end
  end
end
# rubocop:enable RSpecRails/HaveHttpStatus
