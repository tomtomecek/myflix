class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video
  delegate :name, to: :category, prefix: :category

  before_create :set_position

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end

  def set_position()
    if user.queue_items.any?
      number = user.queue_items.last.position
    else
      number = 0
    end
    number += 1
    self.position = number
  end

end