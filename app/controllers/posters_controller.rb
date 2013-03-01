class PostersController < ApplicationController

  def create
    @poster = Poster.new(message: params[:body], user_id: params[:sender])
    if @poster.save
      redirect_to :back
    end
  end

  def destroy
    Poster.find(params[:id]).destroy
    @id = params[:id]
    respond_to do |format|
      format.js
    end
  end
end
