class UsersSearchesController < ApplicationController

  def create

    users = User.search do
      fulltext params[:user_name]
      without :id, current_user.id
    end
    @users = users.results
    respond_to do |format|
          format.html
          format.js
        end
  end
end
