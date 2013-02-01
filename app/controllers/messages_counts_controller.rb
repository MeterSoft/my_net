class MessagesCountsController < ApplicationController

  def index
    current_user.ping = Time.now
  end

end
