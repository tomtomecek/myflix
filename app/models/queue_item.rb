class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, only_integer: true

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video
  delegate :name, to: :category, prefix: :category

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(rating: new_rating, user: user, video: video)
      review.save(validate: false)
    end
  end

  private

  def review
    @review ||= Review.find_by(user_id: user.id, video_id: video.id)
  end
end
