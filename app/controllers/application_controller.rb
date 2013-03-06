class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user

  helper_method :logged_in?
  helper_method :current_user

  before_filter :lenguage
  #before_filter :authenticate_user!
  before_filter :messages_count
  before_filter :friends

  layout :layout_by_resource

  protected

  #def after_sign_out_path_for(resource_or_scope)
  #  new_user_session_path
  #end
  #
  #def after_sign_in_path_for(resource_or_scope)
  #  main_page_path(current_user)
  #end

  def logged_in?
    !!current_user
  end

  def layout_by_resource
    if logged_in?
      "login"
    else
      "application"
    end
  end

  def friends
    @friends = current_user.friends.where(:status => 'confirmed') if current_user
    @inverse_friends = current_user.inverse_friends.where(:status => 'confirmed') if current_user
  end

  def messages_count
    user_status if current_user
  end

  def lenguage
    I18n.locale = current_user.lenguage if current_user
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

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end

  protected

  def authenticate_user
    redirect_to '/sessions/new' unless logged_in?
  end

end
