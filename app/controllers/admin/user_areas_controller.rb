class Admin::UserAreasController < ApplicationController
  before_action :authenticate_user!

  def destroy
    if @user_area = PafsCore::UserArea.find(params[:id])
      user = @user_area.user
      @user_area.destroy

      redirect_to edit_admin_user_path(user)
    end
  end
end
