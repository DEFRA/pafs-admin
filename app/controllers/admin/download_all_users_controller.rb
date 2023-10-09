# frozen_string_literal: true

module Admin
  class DownloadAllUsersController < ApplicationController
    def show
      @users = User.select("id", "email", "first_name", "last_name", "last_sign_in_at", "admin")

      respond_to do |format|
        format.html
        format.xls { send_data @users.to_xls, content_type: "application/vnd.ms-excel", filename: "all_users.xls" }
      end
    end

  end
end
