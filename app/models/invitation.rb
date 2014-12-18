class Invitation < ActiveRecord::Base
  include Tokenable

  after_create :generate_token
    
  belongs_to :sender, class_name: "User"
  
  VALID_REGEX_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,}\z/i
  validates_format_of :recipient_email, with: VALID_REGEX_EMAIL
  validates_presence_of :recipient_name, :message
end