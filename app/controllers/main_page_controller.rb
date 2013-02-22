class MainPageController < ApplicationController

  def index
     @posters = current_user.posters.all
  end

  def show
    @user = User.find(params[:id])
    @posters = @user.posters.all
  end

end
