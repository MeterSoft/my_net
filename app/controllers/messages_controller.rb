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
        flash.now[:notice] = t("messages.create.message_is_sent")
        format.js
      else
        @user = User.find(params[:user_id])
        current_user.send_message(@user, params[:body], params[:subject])
        format.html { redirect_to messages_path }
        flash.now[:notice] = t("messages.create.message_is_sent")
        format.js
      end
    end
  end

  def show
    respond_to do |format|
      conversation = current_user.mailbox.conversations.find(params[:id])
      format.html{
        @messages = conversation.messages.last(30)
        @conversation = conversation.id
        current_user.mark_as_read(conversation)
      }
      format.json {
        new_message = conversation.receipts.where(is_read: false, receiver_id: current_user.id)
        if new_message != []
          new_message_json = new_message.map{|m| {:body => m.message.body, :created_at => m.message.created_at.strftime('%e.%m.%y  %T'), :avatar_url => m.message.sender.avatar_url} }.to_json
          current_user.mark_as_read(conversation)
          render json: new_message_json
        else
          render json: { status: "OK" }
        end
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

end
