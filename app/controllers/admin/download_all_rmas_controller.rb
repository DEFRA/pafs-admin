# frozen_string_literal: true

module Admin
  class DownloadAllRmasController < ApplicationController
    def show
      @rma_list = rma_list
      # replace area codes with names
      replace_area_codes_with_names

      respond_to do |format|
        format.html
        format.xls do
          export
        end
      end
    end

    private

    def rma_list
      Organisation.rma_areas
                  .joins("LEFT JOIN pafs_core_areas AS authorities \
                          ON authorities.area_type='Authority' \
                          AND authorities.identifier = pafs_core_areas.sub_type")
                  .joins("LEFT JOIN pafs_core_areas AS pso \
                          ON pso.area_type='PSO Area' \
                          AND pso.id = pafs_core_areas.parent_id")
                  .select(
                    "pafs_core_areas.identifier AS rma_identifier",
                    "pafs_core_areas.name AS rma_name",
                    "pafs_core_areas.sub_type AS authority_code",
                    "authorities.name AS authority_type",
                    "pso.name AS pso_team",
                    "pso.sub_type AS pso_area",
                    "pafs_core_areas.end_date"
                  )
    end

    def replace_area_codes_with_names
      @rma_list.each do |rma|
        rma.pso_area = PafsCore::RFCC_CODE_NAMES_MAP[rma.pso_area]
      end
    end

    def export
      send_data @rma_list.to_xls(
        columns: %i[rma_identifier authority_type rma_name authority_code pso_team
                    pso_area end_date],
        headers: ["Identifier", "Type", "Name", "Code", "PSO Team",
                  "Area", "End Date"]
      ), content_type: "application/vnd.ms-excel", filename: "all_rma.xls"
    end
  end
end
