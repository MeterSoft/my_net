class MessagesCountsController < ApplicationController

  def index
    @invite = current_user.inverse_friends.where(:status => 'invite').count
    @invite = nil if @invite == 0
    @count = current_user.receipts.where(is_read: false).count if current_user
    @count = nil if @count == 0
    respond_to do |format|
      format.json { render json: {count: @count, invite: @invite} }
    end
  end

end
