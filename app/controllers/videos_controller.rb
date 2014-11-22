class VideosController < ApplicationController

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @result = Video.search_by_title(params[:query])
  end


end