# frozen_string_literal: true

module Admin
  class Camc3Controller < ApplicationController
    before_action :authenticate_user!, :endpoint_enabled?
    respond_to :json

    def show
      @project = PafsCore::Project.find_by(slug: params[:id])
      @camc3 = PafsCore::Camc3Presenter.new(project: @project)

      respond_with @camc3.attributes
    end

    protected

    def endpoint_enabled?
      return false if ENV.fetch("ENABLE_ADMIN_JSON_PREVIEW", false)

      head status: 404
    end
  end
end
