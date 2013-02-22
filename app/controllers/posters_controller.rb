class PostersController < ApplicationController

  def create
    @poster = Poster.new(message: params[:body], user_id: params[:sender])
    if @poster.save
      redirect_to :back
    end
  end
end
