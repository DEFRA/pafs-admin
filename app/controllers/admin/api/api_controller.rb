# frozen_string_literal: true

module Admin
  module Api
    class ApiController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authorize_api_access
      respond_to :json

      private

      def authorize_api_access
        return true if remote_auth_token == auth_token

        render_unauthorized
      end

      def render_unauthorized
        head :unauthorized
      end

      def render_error
        head :unprocessable_entity
      end

      def render_missing
        head :not_found
      end

      def auth_token
        request.headers.fetch("Authorization", "").gsub(/^Bearer /, "")
      end

      def remote_auth_token
        @remote_auth_token ||= PafsCore::Pol::AzureVaultClient.fetch(
          ENV.fetch("AZURE_VAULT_AUTH_TOKEN_KEY_NAME_RECEIVE")
        )
      end
    end
  end
end
