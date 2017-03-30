# frozen_string_literal: true
class Admin::RefreshController < ApplicationController
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
    true
  end
end
