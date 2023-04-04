# frozen_string_literal: true

module Admin
  class ProjectsController < ApplicationController
    before_action :authenticate_user!

    helper_method :project_sort_order, :project_sort_column

    def index
      # dashboard page
      # (filterable) list of projects
      @projects = navigator.search(params.merge(access_all_areas: true))

      if params[:all]
        projects_per_page = @projects.any? ? @projects.size : 1
      else
        page = params.fetch(:page, 1)
        projects_per_page = params.fetch(:per, 10)
      end

      @projects = @projects.page(page).per(projects_per_page)
    end

    def edit
      @project = PafsCore::Project.find_by(reference_number: params[:id].gsub("-", "/"))
    end

    def save
      @project = PafsCore::Project.find_by(reference_number: params[:id].gsub("-", "/"))
      @new_rma = PafsCore::Area.find(params[:rma_id])

      return redirect_save_no_change if @new_rma == @project.owner

      return redirect_save_success if PafsCore::ChangeProjectAreaService.new(@project).run(@new_rma)

      redirect_save_failure
    rescue StandardError => e
      message = "Error changing RMA for project #{params[:id]} to #{params[:rma_id]}"
      Rails.logger.error message
      Airbrake.notify(e, message: message)

      redirect_save_failure
    end

    private

    def navigator
      @navigator ||= PafsCore::ProjectNavigator.new current_resource
    end

    def project_sort_column
      params[:sort_col].to_s
    end

    def project_sort_order
      params[:sort_order].to_s
    end

    def redirect_save_success
      redirect_to admin_projects_path
    end

    def redirect_save_no_change
      redirect_back fallback_location: edit_admin_project_path(@project.reference_number),
                    flash: { alert: t(".not_changed") }
    end

    def redirect_save_failure
      redirect_back fallback_location: edit_admin_project_path(@project.reference_number),
                    flash: { alert: t(".update_failed", reference_number: @project.reference_number) }
    end
  end
end
