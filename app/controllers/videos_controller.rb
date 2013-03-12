class VideosController < ApplicationController

  def index
    @videos = current_user.videos.all
  end
end
