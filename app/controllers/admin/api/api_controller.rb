module Admin::Api
  class ApiController < ApplicationController
    before_action :authorize_api_access
    respond_to :json

    private

    def authorize_api_access
      return true if remote_auth_token == auth_token

      render_unauthorized
    end

    def render_unauthorized
      head status: 401
    end

    def auth_token
      request.headers.fetch("Authorization", '').gsub(/^Bearer /, '')
    end

    def remote_auth_token
      @remote_auth_token ||= PafsCore::Pol::AzureVaultClient.fetch(
        ENV.fetch('AZURE_VAULT_AUTH_TOKEN_KEY_NAME_RECEIVE')
      )
    end
  end
end

