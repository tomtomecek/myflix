class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :email, :password, :fullname, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end