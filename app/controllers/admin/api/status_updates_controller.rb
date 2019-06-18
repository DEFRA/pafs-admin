module Admin::Api
  class StatusUpdatesController < ApiController
    def create
      return render_error if update_params.fetch('Status', '') != 'Draft'
      return render_error unless project.state.update_column(:state, 'draft')

      head status: 204
    end

    private

    def render_error
      head status: 422
    end

    def update_params
      @update_params ||= params.permit('NPN', 'Status')
    end

    def project
      @project ||= PafsCore::Project.find_by!(reference_number: update_params.fetch('NPN'))
    end
  end
end
