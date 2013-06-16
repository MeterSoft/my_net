class MessagesCountsController < ApplicationController
  skip_before_filter :lenguage

  def index
  	if current_user
	  	current_user.update_attributes(time: Time.now)
	    @invite = current_user.pending_inverse_friends.count
	    @invite = nil if @invite == 0
	    @count = current_user.receipts.where(is_read: false, receiver_id: current_user.id).count 
	    @count = nil if @count == 0
	    respond_to do |format|
	      format.json { render json: {count: @count, invite: @invite} }
	    end
	end
  end

end
