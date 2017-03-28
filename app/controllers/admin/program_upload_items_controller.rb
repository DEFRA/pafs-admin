# frozen_string_literal: true
class Admin::ProgramUploadItemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @upload = PafsCore::ProgramUpload.find(params[:program_upload_id])
    @item = @upload.program_upload_items.find(params[:id])
    @errors = @item.program_upload_failures.order(:field_name)
  end
end
