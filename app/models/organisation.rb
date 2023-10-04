# frozen_string_literal: true

class Organisation < PafsCore::Area
  ORGANISATION_TO_AREA_MAPPING = {
    "Authority" => "Authority",
    "PSO" => "PSO Area",
    "RMA" => "RMA"
  }.freeze

  paginates_per 20
end
