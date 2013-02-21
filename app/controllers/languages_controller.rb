class LanguagesController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    I18n.locale = params[:locale]
    current_user.update_attributes(lenguage: params[:locale]) if current_user
    redirect_to :back
  end
end
