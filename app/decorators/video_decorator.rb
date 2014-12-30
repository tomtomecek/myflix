class VideoDecorator < Draper::Decorator
  delegate_all

  def dec_rating
    if model.rating
      "#{model.rating} / 5.0"
    else
      "N/A"
    end
  end
end