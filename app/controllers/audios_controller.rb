class AudiosController < ApplicationController

  def index
    @audios = current_user.audios.all
  end
end
