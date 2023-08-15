# frozen_string_literal: true

module Admin
  class OrganisationsController < ApplicationController
    before_action :authenticate_user!

    def index
      q = params.fetch(:q, nil)
      type = params.fetch(:type, PafsCore::Organisation::RMA)
      page = params.fetch(:page, "1").to_i

      unless PafsCore::Organisation::ORGANISATION_TYPES.include?(type)
        flash[:notice] = "Invalid organisation type: #{type}"
        type = PafsCore::Organisation::RMA
      end

      @organisations = Organisation.all
      @organisations = @organisations.where(organisation_type: type) if type.present?
      @organisations = @organisations.where("name ILIKE ?", "%#{q}%") if q.present?
      @organisations = @organisations.order(name: "asc").page(page)
    end
  end
end
