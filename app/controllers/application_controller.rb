class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :messages_count

  layout :layout_by_resource

  protected

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    main_page_index_path
  end

  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end

  def messages_count
    user_status if current_user
    friend_invite if current_user
    @count = current_user.receipts.where(is_read: false).count if current_user
    @count = nil if @count == 0
  end

  def user_status
    current_user.update_attributes(:time => Time.now)
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

  def friend_invite
    @invite = current_user.inverse_friends.where(:status => 'invite').count
    @invite = nil if @invite == 1
  end

end
