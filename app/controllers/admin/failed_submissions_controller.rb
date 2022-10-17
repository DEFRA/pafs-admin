# frozen_string_literal: true

module Admin
  class FailedSubmissionsController < ApplicationController
    before_action :authenticate_user!
    helper_method :projects, :project_sort_order, :project_sort_column

    def mark_as_submitted
      project.update(submitted_to_pol: Time.now.utc)
      redirect_back(fallback_location: root_path)
    end

    def retry_submission
      return redirect_success if submission.perform

      redirect_failure
    end

    private

    def redirect_success
      redirect_back fallback_location: root_path,
                    flash: { notice: "#{project.reference_number} Successfully resubmitted" }
    end

    def redirect_failure
      redirect_back fallback_location: root_path,
                    flash: { alert: "#{project.reference_number} Failed to resubmit" }
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
      @project ||= scope.find_by(slug: params[:id])
    end

    def project_sort_column
      params[:sort_col].to_s
    end

    def project_sort_order
      params[:sort_order].to_s
    end
  end
end
