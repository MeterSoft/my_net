class PostsController < ApplicationController
  before_filter :find_post, only: [:index, :edit, :update, :like, :destroy]
  layout false

  def index
    @replies = @post.replies
  end

  def create
    @post = Post.new(params[:post])

    if @post.save
      flash.now[:notice] = t(".posts.create.post_was_create")
    else
      flash.now[:error] = t(".posts.create.post_was_error")
    end
  end

  def edit
  end

  def update
    @post.update_attributes(message: params[:post][:message])    
  end    

  def like
    current_user.voted_up_on?(@post) ? current_user.dislikes(@post) : current_user.likes(@post)
  end

  def destroy
    @post.destroy
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end
end
