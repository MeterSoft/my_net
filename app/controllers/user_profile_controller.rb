class UserProfileController < ApplicationController
  before_filter :profile, only: [:show, :edit, :update]
  before_filter :check_permissions, only: [:edit, :update]

  def edit
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to main_page_path(current_user.id) }
        format.json
      else
        format.html { render action: "edit" }
        format.json
      end
    end
  end

  def subregion_options
    render partial: 'subregion_select'
  end

  private

  def profile
    @user = User.find(params[:id])
  end

  def check_permissions
    redirect_to root_path if @user != current_user
  end
end
