class Admin::DownloadsController < ApplicationController
  before_action :authenticate_user!
  helper_method :download_state, :meta

  def show
    respond_to do |format|
      format.html { request.xhr? ? render_state : render(:show) }
      format.xlsx do
        (download_state == 'complete') ? send_spreadsheet : head(404)
        return
      end
    end
  end

  def create
    GenerateAllFcrm1DownloadJob.perform_later(current_user.id)
    update_status(status: "pending")
    redirect_to admin_download_path
  end

  protected

  def send_spreadsheet
    PafsCore::Download::All.new.fetch_remote_file do |data|
      send_data data, type: 'application/xlsx', filename: "all.xlsx"
    end
  end

  def update_status(data)
    meta_class.create({ last_update: Time.now.utc }.merge(data))
  end

  def render_state
    render partial: "pending.html.erb"
  end

  def download_state
    return 'blank_slate' unless meta.present?

    meta.fetch('status', 'blank_slate')
  end

  def meta_class
    @meta_class ||= PafsCore::Download::All.new.meta
  end

  def meta
    @meta ||= meta_class.load
  end
end
