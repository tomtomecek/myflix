class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates :title, :description, presence: true

  def self.search_by_title(title)
    return [] if title.blank?
    where("title LIKE ?", "%#{title}%")
  end

  def total_reviews
    self.reviews.count
  end

  def average_rating
    if reviews.any?
      (reviews.map(&:rating).inject(:+) / reviews.count).to_f
    else
      0.0
    end
  end

end