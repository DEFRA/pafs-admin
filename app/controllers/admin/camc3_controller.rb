class Admin::Camc3Controller < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def show
    @project = PafsCore::Project.find_by_slug(params[:id])
    @camc3 = PafsCore::Camc3Presenter.new(project: @project)

    respond_with @camc3.attributes
  end
end
