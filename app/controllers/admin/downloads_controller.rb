# frozen_string_literal: true

module Admin
  class DownloadsController < ApplicationController
    before_action :authenticate_user!
    helper_method :download_state, :meta

    def show
      respond_to do |format|
        format.html { request.xhr? ? render_state : render(:show) }
        format.xlsx do
          download_state == "complete" ? send_spreadsheet : head(:not_found)
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
      redirect_to PafsCore::Download::All.new.remote_file_url
    end

    def update_status(data)
      meta_class.create({ last_update: Time.now.utc }.merge(data))
    end

    def render_state
      render partial: "pending.html.erb"
    end

    def download_state
      return "blank_slate" if meta.blank?

      meta.fetch("status", "blank_slate")
    end

    def meta_class
      @meta_class ||= PafsCore::Download::All.new.meta
    end

    def meta
      @meta ||= meta_class.load
    end
  end
end
