class UsersSearchesController < ApplicationController

  def index
    @users = User.all
  end

end
