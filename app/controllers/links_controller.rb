class LinksController < ApplicationController

  def index
    preview_link = PreviewLink.new(params[:url])
    render json: preview_link.link_info
  end
end
