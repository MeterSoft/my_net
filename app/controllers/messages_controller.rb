class MessagesController < ApplicationController

  def index
    @messages = current_user.mailbox.inbox
  end

  def new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    current_user.send_message(@user, params[:body], params[:subject])
    redirect_to messages_path
  end
end
