class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :reviews

  before_create { |user| user.email = user.email.downcase }

  validates :email, :password, :fullname, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end