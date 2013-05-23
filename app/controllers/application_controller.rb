class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :lenguage
  before_filter :authenticate_user!
  before_filter :user_status

  layout :layout_by_resource

  protected

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    current_user.update_attributes(:ip_address => request.ip)
    current_user.setting = Setting.new(user_id: current_user.id) unless current_user.setting
    root_path
  end

  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end

  def lenguage
    I18n.locale = current_user.lenguage if current_user
  end

  def user_status
    if current_user
      current_user.update_attributes(time: Time.now)
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

end
