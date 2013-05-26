class UserProfileController < ApplicationController

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

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
end
