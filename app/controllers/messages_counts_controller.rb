class MessagesCountsController < ApplicationController

  def index
    current_user.ping = Time.now
  end

  def user_status
      if current_user
        if current_user.ping
          if (Time.now - current_user.ping > 30)
            current_user.status = 'offline'
          else
            current_user.status = 'online'
          end
        end
      end
    end

end
