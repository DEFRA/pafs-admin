# frozen_string_literal: true

module Admin
  class ProgramUploadsController < ApplicationController
    before_action :authenticate_user!

    def show
      page = params.fetch(:page, 1)
      items_per_page = params.fetch(:per, 50)
      @upload = PafsCore::ProgramUpload.find(params[:id])
      @items = @upload.program_upload_items.order(created_at: :asc).page(page).per(items_per_page)
      if request.xhr?
        render partial: "status.html.erb"
      else
        render "show"
      end
    end

    def create
      @upload = program_uploader.upload(program_uploads_params)

      if @upload.valid? && @upload.save
        # start the background job
        PafsCore::ImportProgramRefreshJob.perform_later @upload.id
        # the show page will contain progress updates while processing
        redirect_to main_app.admin_program_upload_path(@upload)
      else
        render "new"
      end
    end

    private

    def program_uploads_params
      params.require(:program_upload).permit(:program_upload_file, :reset_consented_flag)
    end

    def program_uploader
      @program_uploader ||= PafsCore::ProgramUploadService.new
    end
  end
end
