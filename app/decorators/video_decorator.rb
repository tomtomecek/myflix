class VideoDecorator < Draper::Decorator
  delegate_all

  def average_rating
    model.average_rating.present? ? "#{model.average_rating} / 5.0" : "N/A"
  end
end
