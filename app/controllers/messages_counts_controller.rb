class MessagesCountsController < ApplicationController

  def index
    @invite = current_user.pending_inverse_friends.count
    @invite = nil if @invite == 0
    @count = current_user.receipts.where(is_read: false, receiver_id: current_user.id).count if current_user
    @count = nil if @count == 0
    respond_to do |format|
      format.json { render json: {count: @count, invite: @invite} }
    end
  end

end
