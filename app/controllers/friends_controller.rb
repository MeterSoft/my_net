class FriendsController < ApplicationController

  before_filter :find_user, only: [:create, :destroy] 

  def index
    @friends = current_user.all_friends
    @pending_friends = current_user.pending_inverse_friends
  end

  def create
    unless current_user.friend_invited?(@user)
      @friendship = current_user.friendship_with(@user)
      if @friendship
        @friendship.update_attributes(:status => "approved")
      else
        @friend = Friendship.new(:user_id => current_user.id, :friend_id => params[:user_id], :status => 'pending')
      end
    end
    redirect_to :back
  end

  def destroy
    if current_user.friendship_with(@user).destroy
      redirect_to :back
    end
  end

  private

  def find_user
    @user = User.find(params[:id] || params[:user_id])
  end

end
