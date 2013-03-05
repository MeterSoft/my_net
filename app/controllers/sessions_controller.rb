class SessionsController < ApplicationController

  skip_before_filter :authenticate_user!

  layout "login"

  def new
    srand
    session[:state] ||= Digest::MD5.hexdigest(rand.to_s)
    @vk_url = VkontakteApi.authorization_url(scope: [:friends, :photos, :audio, :video, :offline, :notify], state: session[:state])
  end

end