class MainPageController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posters = @user.posters.all
  end

end
