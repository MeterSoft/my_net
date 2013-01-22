class MessagesController < ApplicationController

  def index
    @messages = current_user.mailbox.conversations
    binding.pry
  end

  def new
    @user = User.find(params[:user_id])
  end

  def create
    #raise params.inspect
    user = User.search do
      fulltext params[:user_name]
    end
    current_user.send_message(user.results, params[:body], params[:subject])
  end
end
