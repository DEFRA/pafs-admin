# frozen_string_literal: true

RSpec.feature 'Status update callback', type: :request do
  let(:project) { create(:project, :submitted) }
  let(:status) { 'Draft' }
  let(:payload) { { "NPN": project.reference_number, "Status": status } }
  
  let(:headers) do
    {
      "Authorization": auth_token,
      "Content-Type": "application/json"
    }
  end

  let(:perform) { post '/admin/api/project/status', payload.to_json, headers }
  let(:auth_token) { 'Bearer VALID' }

  before do
    allow(ENV).to receive(:fetch).with('AZURE_VAULT_AUTH_TOKEN_KEY_NAME_RECEIVE').and_return('TOKEN_NAME')
    allow(PafsCore::Pol::AzureVaultClient).to receive(:fetch).with('TOKEN_NAME').and_return('VALID')
  end

  context 'with an invalid auth token' do
    let(:auth_token) { 'Bearer INVALID' }

    scenario 'the project is not changed' do
      expect do
        perform
      end.not_to change { project.reload.status }
    end

    scenario 'the endpoint responds with unauthorized' do
      perform
      expect(response.status).to eql(401)
    end
  end

  context 'with a valid auth token' do
    context 'with a missing project' do
      let(:payload) { { "NPN": "INVALID", "Status": status } }

      scenario 'the endpoint responds with a 404' do
        perform
        expect(response.status).to eql(404)
      end
    end

    context 'with an invalid payload' do
      let(:payload) { { "NPN": project.reference_number, "Status": "INVALID" } }

      scenario 'the endpoint responds with a 422' do
        perform
        expect(response.status).to eql(422)
      end

      scenario 'no changes happen to the project' do
        expect do
          perform
        end.not_to change { project.reload.status }
      end
    end

    context 'with a valid payload' do
      scenario ' the endpoint responds with a 204' do
        perform
        expect(response.status).to  eql(204)
      end

      scenario 'the status of the project is set to draft' do
        expect do
          perform
        end.to change { project.reload.status }.to(:draft)
      end
    end
  end
end
