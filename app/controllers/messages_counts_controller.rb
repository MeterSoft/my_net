class MessagesCountsController < ApplicationController

  def index
      @count = 0
      current_user.mailbox.inbox.each do |i|
        if i.is_unread?(current_user)
          @count+=1
        end
      end
  end

end
