class MessagesCountsController < ApplicationController

  def index
    current_user.update_attributes(:time => Time.now)
    user_status
  end

  def user_status
    User.all.each do |u|
      if u.time
        if (Time.now - u.time < 30)
          u.update_attributes(:status => "online")
        else
          u.update_attributes(:status => "offline")
        end
      end
    end
  end

end
