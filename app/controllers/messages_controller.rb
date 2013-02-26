class MessagesController < ApplicationController

  def index
    @messages = current_user.mailbox.conversations
  end

  def new
    @user = User.find(params[:user_id])
  end

  def create
    if params[:conversation]
      conversation = current_user.mailbox.conversations.find(params[:conversation])
    else
      conversation = is_conversation?(params[:user_id])
    end
    respond_to do |format|
      if conversation
        current_user.reply_to_conversation(conversation, params[:body])
        message = conversation.messages.last
        format.json { render json: { status: "OK" } }
        format.html { redirect_to message_path(conversation) }
      else
        @user = User.find(params[:user_id])
        current_user.send_message(@user, params[:body], params[:subject])
        format.html { redirect_to messages_path }
      end
    end
  end

  def show
    conversation = current_user.mailbox.conversations.find(params[:id])
    @messages = conversation.messages.last(30)
    @conversation = conversation.id
    current_user.mark_as_read(conversation)
    messages_count
  end

  def is_conversation?(user_id)
    current_user.mailbox.conversations.each do |c|
      ids = c.recipients.map(&:id)
      if ids.include?(user_id.to_i)
        return c
      end
    end
    return false
  end

  #def destroy
  #  current_user.mailbox.inbox.find(params[:conversation]).messages.find(params[:id]).destroy
  #  render :nothing => true
  #end

end
