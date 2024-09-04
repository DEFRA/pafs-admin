# frozen_string_literal: true

module Admin
  class DownloadAllUsersController < ApplicationController
    def show
      @users = User.all
      @export_data = []
      @users.each do |user|
        @export_data << prepare_export_row(user)
      end

      respond_to do |format|
        format.html
        format.xls do
          export
        end
      end
    end

    private

    def prepare_export_row(user)
      areas = fetch_user_areas(user)
      row = {
        id: user.id,
        email: user.email,
        last_name: user.last_name,
        first_name: user.first_name,
        main_area: areas[:main_area],
        first_area: areas[:first_area],
        second_area: areas[:second_area],
        third_area: areas[:third_area],
        admin: user.admin? ? "Yes" : "No",
        invitation_sent_at: format_date(user.invitation_sent_at),
        invitation_accepted_at: format_date(user.invitation_accepted_at),
        last_sign_in_at: format_date(user.last_sign_in_at)
      }
      Struct.new(*row.keys).new(*row.values)
    end

    def fetch_user_areas(user)
      primary_area = user.user_areas.find_by(primary: true)&.area&.try(:name)
      non_primary_areas = user.user_areas.reject(&:primary).map { |ua| ua.area&.try(:name) }
      {
        main_area: primary_area,
        first_area: non_primary_areas[0],
        second_area: non_primary_areas[1],
        third_area: non_primary_areas[2]
      }
    end

    def format_date(date)
      date&.strftime("%Y.%m.%d")
    end

    def export
      send_data @export_data.to_xls(
        columns: %i[id email last_name first_name
                    main_area first_area second_area third_area
                    admin invitation_sent_at invitation_accepted_at
                    last_sign_in_at],
        headers: ["Id", "Email", "Last Name", "First Name",
                  "Main Area", "1st Area", "2nd Area", "3rd Area",
                  "Admininstrator?", "Invitation sent", "Invitation accepted", "Last sign in"]
      ), content_type: "application/vnd.ms-excel", filename: "all_users.xls"
    end
  end
end
