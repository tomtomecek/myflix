class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order(:position) }
  has_many :relationships, foreign_key: "follower_id"
  has_many :followings, through: :relationships, source: :followed

  before_create { |user| user.email = user.email.downcase }

  validates_presence_of :email, :password, :fullname
  validates_uniqueness_of :email, case_sensitive: false
  
  def owns?(queue_item)
    self.queue_items.include?(queue_item)
  end

  def normalizes_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def followers_total
    Relationship.where(followed_id: id).count
  end

end