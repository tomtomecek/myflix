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

  def advanced_search
    options = {
      reviews:     params[:reviews],
      rating_from: params[:rating_from],
      rating_to:   params[:rating_to]
    }
    results = Video.search(params[:query], options).results
    @results = results.map { |hit| VideoSearchDecorator.new(hit) }
  end
end
