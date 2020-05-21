class Admin::DownloadsController < ApplicationController
  before_action :authenticate_user!
  helper_method :download_state, :meta

  def show
    return render_state if download_state == 'pending' && request.xhr?
  end

  def create
    GenerateAllFcrm1DownloadJob.perform_later(current_user.id)
    update_status(status: "pending")
    redirect_to admin_download_path
  end

  protected

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
