class FriendsController < ApplicationController

  def index
  end

  def create
    if params[:user_id]
      @friend = Friend.new(:user_id => current_user.id, :user_friend_id => params[:user_id], :status => 'invite')
      if @friend.save
        redirect_to main_page_index_path
      end
    else
      Friend.find(params[:user_confirmed_id]).update_attributes(:status => "confirmed")
      redirect_to main_page_index_path
    end
  end

end
