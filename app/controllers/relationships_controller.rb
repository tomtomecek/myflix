class RelationshipsController < ApplicationController
  before_action :require_user

  def people
    @followings = current_user.followings
  end

  # def destroy
  # end

end