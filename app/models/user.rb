class User < ActiveRecord::Base
  include Tokenable

  has_secure_password validations: false
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order(:position) }
  has_many :following_relationships, class_name: "Relationship",
                                     foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship",
                                     foreign_key: :leader_id
  has_many :subscriptions

  before_create { |user| user.email = user.email.downcase }

  validates_presence_of :email, :password, :fullname
  validates_uniqueness_of :email, case_sensitive: false
  validates_length_of :password, minimum: 6

  def owns?(queue_item)
    queue_items.include?(queue_item)
  end

  def normalizes_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end

  def can_follow?(another_user)
    !(follows?(another_user) || self == another_user)
  end

  def set_token_to_nil
    update_column(:token, nil)
  end

  def deactivate!
    update_column(:activated, false)
  end
end