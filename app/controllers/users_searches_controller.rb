class UsersSearchesController < ApplicationController
  layout false

  def index
    search = params[:search].split(' ')
    @users = User.where('lower(first_name) IN(lower(?)) OR lower(last_name) IN(lower(?))', search, search)
    respond_to do |format|
      format.js
    end
  end

end