# frozen_string_literal: true

module Admin
  class RefreshController < ApplicationController
    before_action :authenticate_user!

    def new
      @confirmation = Confirmation.new(confirm: false)
    end

    def create
      @confirmation = Confirmation.new(confirmation_params)
      if @confirmation.valid?
        # reset the project states to "update"
        open_programme
        # show a success page
      else
        render "new"
      end
    end

    private

    def confirmation_params
      params.require(:confirmation).permit(:confirm)
    end

    def open_programme
      # update the status of projects
      # TODO: when time allows change this to "updatable"
      # rubocop:disable Rails/SkipsModelValidations
      PafsCore::State.refreshable.update_all(state: "draft")
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
