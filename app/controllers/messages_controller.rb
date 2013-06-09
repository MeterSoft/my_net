class MessagesController < ApplicationController

  def index
    @messages = current_user.mailbox.conversations
  end

  def new
    @user = User.find(params[:user_id])
  end

  def create
    if params[:conversation]
      @conversation = current_user.mailbox.conversations.find(params[:conversation])
    else
      @conversation = is_conversation?(params[:user_id])
    end

    if @conversation
      current_user.reply_to_conversation(@conversation, params[:body])
      @message = @conversation.messages.last
    else
      @user = User.find(params[:user_id])
      current_user.send_message(@user, params[:body], params[:subject])
    end
    @chat = true if params[:conversation]
  end

  def show
    respond_to do |format|
      conversation = current_user.mailbox.conversations.find(params[:id])
      format.html{
        @messages = conversation.messages.order(:id).last(30)
        @conversation = conversation.id
        current_user.mark_as_read(conversation)
        @user = companion(conversation)
      }
    end
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

  def destroy
    current_user.mailbox.inbox.find(params[:id]).destroy
    @id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  private

  def new_messages_count
    count = current_user.receipts.where(is_read: false, receiver_id: current_user.id).count
    return nil if count == 0
  end

  def companion(conversation)
    conversation.messages.each do |message|
      return message.sender unless message.sender.eql?(current_user)
    end
  end

end
