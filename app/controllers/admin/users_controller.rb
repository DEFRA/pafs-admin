# frozen_string_literal: true
class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    q = params.fetch(:q, nil)
    o = params.fetch(:o, nil)
    d = params.fetch(:d, "asc")
    page = params.fetch(:page, "1").to_i

    d = "asc" if d != "asc" && d != "desc"
    @users = if q
               User.search(q)
             else
               User.all.includes(:areas)
             end
    @users = if o && o == "area"
               @users.joins(:areas).merge(PafsCore::Area.order(name: d)).page(page)
             else
               @users.order(last_name: d, first_name: d).page(page)
             end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @user.user_areas.build(primary: true)
  end

  def create
    # invite the user
    @user = User.invite!(user_params) do |u|
      u.skip_invitation = true
    end
    if @user.valid?
      AccountRequestMailer.account_created_email(@user).deliver_now
      @user.update_attributes(invitation_sent_at: Time.now.utc)
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render "edit"
    end
  end

  def reinvite
    @user = User.find(params[:id])
    @user.invite!(current_user) do |u|
      u.skip_invitation = true
    end
    AccountRequestMailer.account_created_email(@user).deliver_now
    @user.update_attributes(invitation_sent_at: Time.now.utc)
    redirect_to edit_admin_user_path(@user)
  end

private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :admin, :disabled,
                                user_areas_attributes: [:id, :area_id, :user_id, :primary])
  end

  def navigator
    @navigator ||= PafsCore::ProjectNavigator.new current_resource
  end
end
