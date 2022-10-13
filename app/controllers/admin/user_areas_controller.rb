# frozen_string_literal: true

module Admin
  class UserAreasController < ApplicationController
    before_action :authenticate_user!

    def destroy
      return unless @user_area == PafsCore::UserArea.find(params[:id])

      user = @user_area.user
      @user_area.destroy

      redirect_to edit_admin_user_path(user)
    end
  end
end
