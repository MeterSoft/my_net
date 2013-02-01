class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :messages_count
  before_filter :user_status

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
    @count = current_user.receipts.where(is_read: false).count if current_user
    @count = nil if @count == 0
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
