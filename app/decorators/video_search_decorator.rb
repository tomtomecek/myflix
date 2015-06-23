class VideoSearchDecorator
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def title
    handle_highlighted :title
  end

  def description
    handle_highlighted :description
  end

  def average_rating
    video.average_rating
  end

  def small_cover_url
    video.small_cover.url
  end

  def reviews_count
    video.reviews.count
  end

  def first_review
    if video.reviews.empty?
      "There are currently no reviews."
    elsif review = video.try(:highlight) && video.highlight["reviews.body"]
      "... #{review.first} ...".html_safe
    else
      video.reviews.first.body
    end
  end

private

  def handle_highlighted(attribute)
    if title = video.try(:highlight) && video.highlight[attribute.to_s]
      title.first.html_safe
    else
      video.send(attribute)
    end
  end
end
