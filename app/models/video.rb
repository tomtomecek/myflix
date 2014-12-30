class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  
  validates_presence_of :title, :description, :video_url

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(title)
    return [] if title.blank?
    where("title LIKE ?", "%#{title}%")
  end

  def rating
    reviews.average(:rating).to_f.round(1) if reviews.any?
  end
end