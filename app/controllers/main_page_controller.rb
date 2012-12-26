class MainPageController < ApplicationController

  def index
     @users = User.all
  end

end
