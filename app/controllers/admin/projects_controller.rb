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
      @project = PafsCore::Project.find_by(reference_number: params[:id].gsub("-", "\/"))
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
  end
end
