class MessagesController < ApplicationController

  def index
    @messages = current_user.mailbox.inbox
  end

  def new
    @user = User.find(params[:user_id])
  end

  def create
    if params[:conversation]
      conversation = current_user.mailbox.conversations.find(params[:conversation])
      current_user.reply_to_conversation(conversation, params[:body])
    else
      @user = User.find(params[:user_id])
      current_user.send_message(@user, params[:body], params[:subject])
    end
    redirect_to message_path(conversation)
  end

  def show
    @conversation = current_user.mailbox.inbox.find(params[:id])
    current_user.mark_as_read(@conversation)
    messages_count
  end

  #def destroy
  #  current_user.mailbox.inbox.find(params[:conversation]).messages.find(params[:id]).destroy
  #  render :nothing => true
  #end

end
