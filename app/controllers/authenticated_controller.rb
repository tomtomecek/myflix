class AuthenticatedController < ApplicationController
  before_action :require_user

  def require_user
    unless logged_in?
      flash[:info] = "Access reserved for members only. Please sign in first."
      redirect_to root_url
    end
  end
end
