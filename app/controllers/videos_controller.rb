class VideosController < AuthenticatedController

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
    @review = Review.new
  end

  def search
    @result = Video.search_by_title(params[:query])
  end

end