class RepliesController < ApplicationController
  layout false

  def create
    @post = Post.find(params[:post_id])
    @reply = Post.new params[:post]
    @reply.receiver = @post.receiver
    @reply.creator = current_user
    @post.replies << @reply
    if @reply
      flash.now[:notice] = t(".posts.create.post_was_create")
    else
      flash.now[:error] = t(".posts.create.post_was_error")
    end
  end
end
