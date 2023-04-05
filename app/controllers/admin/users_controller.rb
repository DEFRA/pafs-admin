# frozen_string_literal: true

module Admin
  # rubocop:disable Metrics/ClassLength
  class UsersController < ApplicationController
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
      number_of_total_areas = (3 - @user.user_areas.count).to_i
      number_of_total_areas.times do
        @user.user_areas.build
      end
    end

    def edit
      @user = User.find(params[:id])
      number_of_total_areas = (4 - @user.user_areas.size).to_i
      number_of_total_areas.times do
        @user.user_areas.build
      end
    end

    def create
      # Calling User.invite! seems to use find_or_create under the covers which results in
      # it updating an existing user rather than rejecting a duplicate email address
      # So we're creating the user first and inviting if valid
      p = user_params.merge(password: Devise.friendly_token.first(8))

      params = param_clean(p)
      user_areas_attributes = params["user_areas_attributes"]
      user_areas_attributes.each do |index, user_area|
        params["user_areas_attributes"].delete(index) if user_area["area_id"].blank? && user_area["primary"] != "true"
      end
      @user = User.create(params)

      if @user.valid?
        # invite the user
        invite_user(@user)
        redirect_to admin_users_path
      else
        number_of_total_areas = (4 - @user.user_areas.size).to_i
        unless @user.valid?
          number_of_total_areas.times do
            @user.user_areas.build
          end
        end
        render :new
      end
    end

    def update
      @user = User.find(params[:id])

      params = param_clean(user_params)
      user_areas_attributes = params["user_areas_attributes"]
      user_areas_attributes.each do |index, user_area|
        params["user_areas_attributes"].delete(index) if user_area["area_id"].blank? && user_area["primary"] != "true"
      end
      params[:admin] = true if params[:admin]

      if @user.update!(params)
        redirect_to admin_users_path
      else
        number_of_total_areas = (4 - @user.user_areas.size).to_i
        unless @user.valid?
          number_of_total_areas.times do
            @user.user_areas.build
          end
        end
        render "edit"
      end
    end

    def destroy
      @user = User.find(params[:id])

      if @user.destroy
        redirect_to admin_users_path, flash: { notice: "User deleted" }
      else
        redirect_to admin_users_path, flash: { alert: "Could not delete user" }
      end
    end

    def reinvite
      @user = User.find(params[:id])
      invite_user(@user)
      redirect_to edit_admin_user_path(@user)
    end

    private

    def user_params
      params.require(:user).permit(:first_name,
                                   :last_name,
                                   :email,
                                   admin: [],
                                   user_areas_attributes: %i[id area_id user_id primary])
    end

    def param_clean(params)
      params.delete_if do |_k, v|
        param_clean(v) if v.instance_of?(ActionController::Parameters)
        v.empty?
      end
    end

    def invite_user(user)
      user.invite!(current_user) do |u|
        u.skip_invitation = true
      end
      AccountRequestMailer.account_created_email(user).deliver_now
      user.update!(invitation_sent_at: Time.now.utc)
    end

    def navigator
      @navigator ||= PafsCore::ProjectNavigator.new current_resource
    end
  end
  # rubocop:enable Metrics/ClassLength
end
