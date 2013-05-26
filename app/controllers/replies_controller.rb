class RepliesController < ApplicationController
  layout false

  def create
    @post = Post.find(params[:post_id])
    @reply = Post.new params[:post]
    @reply.receiver = @post.receiver
    @reply.creator = current_user
    @post.replies << @reply
  end
end
