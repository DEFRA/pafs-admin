# frozen_string_literal: true

class Organisation < PafsCore::Area
  AREA_TYPES = [
    AUTHORITY      = "Authority",
    PSO_AREA     = "PSO Area",
    RMA_AREA     = "RMA"
  ].freeze

  paginates_per 20
end
