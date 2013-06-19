class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :lenguage
  before_filter :authenticate_user!

  layout :layout_by_resource

  protected

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    Setting.create(user_id: current_user.id) unless current_user.setting
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
end
