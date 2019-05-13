class Admin::Camc3Controller < ApplicationController
  before_action :authenticate_user!, :endpoint_enabled?
  respond_to :json

  def show
    @project = PafsCore::Project.find_by_slug(params[:id])
    @camc3 = PafsCore::Camc3Presenter.new(project: @project)

    respond_with @camc3.attributes
  end

  protected

  def endpoint_enabled?
    return if ENV.fetch('ENABLE_ADMIN_JSON_PREVIEW', false)
    head status: 404
  end
end
