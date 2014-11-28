class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, only_integer: true
 
  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video
  delegate :name, to: :category, prefix: :category

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end
end