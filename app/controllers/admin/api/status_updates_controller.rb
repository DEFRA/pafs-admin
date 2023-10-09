# frozen_string_literal: true

module Admin
  module Api
    class StatusUpdatesController < ApiController
      def create
        return render_error if update_params.fetch("Status", "") != "Draft"
        return render_error unless project.state.update(state: "draft")

        PafsCore::RemovePreviousYearsService.new(project).run

        head :no_content
      rescue ActiveRecord::RecordNotFound
        render_missing
      end

      private

      def update_params
        @update_params ||= params.permit("NPN", "Status")
      end

      def project
        @project ||= PafsCore::Project.find_by!(reference_number: update_params.fetch("NPN"))
      end
    end
  end
end
