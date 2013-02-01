class MessagesCountsController < ApplicationController

  def index
    current_user.ping = Time.now
  end

  def user_status
    User.all.each do |u|
      if u.ping
        if (Time.now - u.ping > 30)
          u.status = 'offline'
        else
          u.status = 'online'
        end
      end
    end
  end

end
