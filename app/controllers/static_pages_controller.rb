class StaticPagesController < ApplicationController

  def front
    redirect_to home_url if logged_in?
  end
end