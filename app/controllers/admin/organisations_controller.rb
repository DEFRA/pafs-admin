# frozen_string_literal: true

module Admin
  class OrganisationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_organisation, only: %i[edit update]

    def index
      q = params.fetch(:q, nil)
      type = params.fetch(:type, Organisation::RMA_AREA)
      page = params.fetch(:page, "1").to_i

      unless Organisation::AREA_TYPES.include?(type)
        flash[:notice] = "Invalid organisation type: #{type}"
        type = PafsCore::Area::RMA_AREA
      end

      @organisations = Organisation.all
      @organisations = @organisations.where(area_type: type) if type.present?
      @organisations = @organisations.where("name ILIKE ?", "%#{q}%") if q.present?
      @organisations = @organisations.order(name: "asc").page(page)
    end

    def edit
      case @organisation.area_type
      when Organisation::RMA_AREA
        template = "admin/organisations/edit_rma"
      when Organisation::PSO_AREA
        template = "admin/organisations/edit_pso"
      when Organisation::AUTHORITY
        template = "admin/organisations/edit_authority"
      else
        raise "Unsupported organisation type: #{@organisation.area_type}"
      end

      render template
    end

    def update
      @organisation = Organisation.find(params[:id])
      @organisation.update(organisation_params)
      redirect_to admin_organisations_path
    end

    private

    def set_organisation
      @organisation = Organisation.find(params[:id])
    end

    def organisation_params
      params.require(:organisation).permit(:name,
                                           :parent_id,
                                           :sub_type,
                                           :identifier,
                                           :end_date)
    end
  end
end
