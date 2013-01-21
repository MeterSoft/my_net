class UsersController < ApplicationController

  def index
    #raise params.inspect
    #@users = User.find_all_by_first_name(params)
    @users = User.all

    respond_to do |format|
          format.html
          format.js
        end
  end
end
