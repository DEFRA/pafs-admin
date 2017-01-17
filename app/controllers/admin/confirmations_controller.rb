# frozen_string_literal: true
class Admin::ConfirmationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # q = params.fetch(:q, nil)
    # o = params.fetch(:o, nil)
    # d = params.fetch(:d, "asc")
    page = params.fetch(:page, "1").to_i

    d = "asc" if d != "asc" && d != "desc"
    # @users = if q
    #            User.search(q)
    #          else
    #            User.all.includes(:areas)
    #          end
    # @users = if o && o == "area"
    #            @users.joins(:areas).merge(PafsCore::Area.order(name: d)).page(page)
    #          else
    #            @users.order(last_name: d, first_name: d).page(page)
    #          end

    # @submissions = PafsCore::AsiteSubmission.sent_or_unsuccessful.page(page).per(10)
    @submissions = PafsCore::AsiteSubmission.where(id: last_incomplete_submissions).
                   includes(:project).order(:email_sent_at, :id).page(page).per(10)
  end

  # def show
  #   @user = User.find(params[:id])
  # end
  #
  # def reinvite
  #   @user = User.find(params[:id])
  #   invite_user(@user)
  #   redirect_to edit_admin_user_path(@user)
  # end

private
  # def user_params
  #   params.require(:user).permit(:first_name, :last_name, :email, :admin, :disabled,
  #                               user_areas_attributes: [:id, :area_id, :user_id, :primary])
  # end

  def last_incomplete_submissions
    PafsCore::AsiteSubmission.sent_or_unsuccessful.
      group(:project_id).maximum(:id).values
  end

  # def navigator
  #   @navigator ||= PafsCore::ProjectNavigator.new current_resource
  # end
end
