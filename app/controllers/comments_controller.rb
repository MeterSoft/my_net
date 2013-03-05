class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment: params[:comment], poster_id: params[:poster_id])
    @comment.save
    redirect_to :back
  end

  def destroy
    Comment.find(params[:id]).destroy
    @id = params[:id]
    respond_to do |format|
      format.js
    end
  end
end
