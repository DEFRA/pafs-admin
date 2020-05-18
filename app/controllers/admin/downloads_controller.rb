class Admin::DownloadsController < ApplicationController
  before_action :authenticate_user!
  helper_method :download_state

  def show
  end

  def create
    PafsCore::GenerateAllFcrm1DownloadJob.perform_later(current_user.id)
    redirect_to admin_download_path
  end

  protected

  def download_state
    return 'blank_slate' unless meta.present?

    meta.fetch('status', 'blank_slate')
  end

  def meta
    @mete ||= PafsCore::Download::All.new.meta.load
  end
end
