class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    model.rating.present? ? "#{model.rating} / 5.0" : "N/A"
  end
end