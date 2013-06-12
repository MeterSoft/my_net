class UsersSearchesController < ApplicationController
  layout false

  def index
    @users = User.search(params[:search], current_user.id)
    respond_to do |format|
      format.js
    end
  end

end