module Tokenable
  extend ActiveSupport::Concern

  def generate_token
    begin
      the_token = SecureRandom.urlsafe_base64
    end while self.class.exists?(token: the_token)

    update_column(:token, the_token)
  end
end