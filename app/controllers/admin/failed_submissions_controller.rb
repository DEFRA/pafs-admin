# frozen_string_literal: true

class Admin::FailedSubmissionsController < ApplicationController
  before_action :authenticate_user!
  helper_method :projects, :project_sort_order, :project_sort_column

  def index
  end

  def mark_as_submitted
    project.update_column(:submitted_to_pol, Time.now.utc)
    redirect_to :back
  end

  def retry_submission
    return redirect_success if submission.perform
    redirect_failure
  end

  private

  def redirect_success
    redirect_to :back, flash: { notice: "#{project.reference_number} Successfully resubmitted"}
  end

  def redirect_failure
    redirect_to :back, flash: { alert: "#{project.reference_number} Failed to resubmit" }
  end

  def submission
    @submission ||= PafsCore::Pol::Submission.new(project)
  end

  def scope
    @scope ||= PafsCore::Project.submitted.where(submitted_to_pol: nil)
  end

  def projects
    @projects ||= scope.page(params[:page])
  end

  def project
    @project ||= scope.find_by_slug(params[:id])
  end

  def project_sort_column
    params[:sort_col].to_s
  end

  def project_sort_order
    params[:sort_order].to_s
  end
end
