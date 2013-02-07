class UserProfileController < ApplicationController

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        if params[:user][:avatar].blank?
          format.html { redirect_to main_page_index_path, notice: 'Category was successfully updated.' }
          format.json
        else
          format.html { render :action => "crop" }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

end
