class VideosController < ApplicationController
  before_action :require_user

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
    @review = Review.new
  end

  def search
    @result = Video.search_by_title(params[:query])
  end

end