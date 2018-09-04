# frozen_string_literal: true
class Admin::ProgrammeGenerationResetsController < ApplicationController
  before_action :authenticate_user!

  def new
    @confirmation = ProgrammeGenerationResetConfirmation.new(confirm: false)
  end

  def create
    @confirmation = ProgrammeGenerationResetConfirmation.new(confirmation_params)
    if @confirmation.valid?
      # reset the project states to "update"
      reset_programme_generation
      # show a success page
    else
      render "new"
    end
  end

  private
  def confirmation_params
    params.require(:programme_generation_reset_confirmation).permit(:confirm)
  end

  def reset_programme_generation
    # update the status of projects
    # TODO: when time allows change this to "updatable"
    # rubocop:disable Rails/SkipsModelValidations
    PafsCore::AreaDownload.where(status: 'generating').update_all(status: 'failed')
    # rubocop:enable Rails/SkipsModelValidations
  end
end
