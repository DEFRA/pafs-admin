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

    def new
      @organisation = Organisation.new
      return if params[:type].blank?

      @organisation.area_type = params[:type]

      render org_template(@organisation)
    end

    def edit
      render org_template(@organisation, :edit)
    end

    def create
      @organisation = Organisation.new(organisation_params)

      if @organisation.valid?
        @organisation.save
        redirect_to admin_organisations_path
      else
        render org_template(@organisation)
      end
    end

    def update
      @organisation.update(organisation_params)

      if @organisation.valid?
        @organisation.save
        redirect_to admin_organisations_path
      else
        render org_template(@organisation, :edit)
      end
    end

    private

    def org_template(org, action = :new)
      case org.area_type
      when Organisation::RMA_AREA
        action == :new ? :new_rma : :edit_rma
      when Organisation::PSO_AREA
        action == :new ? :new_pso : :edit_pso
      when Organisation::AUTHORITY
        action == :new ? :new_authority : :edit_authority
      end
    end

    def set_organisation
      @organisation = Organisation.find(params[:id])
    end

    def organisation_params
      params.require(:organisation).permit(:name,
                                           :parent_id,
                                           :area_type,
                                           :sub_type,
                                           :identifier,
                                           :end_date)
    end
  end
end
