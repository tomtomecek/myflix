class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.relationships
  end

  def create
    @user = User.find(params[:followed_id])
    relationship = Relationship.new(follower: current_user, followed: @user)

    if relationship.save
      flash[:success] = "You are now following #{@user.fullname}."
    else
      flash[:info] = "You can't follow same person twice."
    end

    redirect_to @user
  end

  def destroy
    begin
      relationship = current_user.relationships.find(params[:id])
      flash[:info] = "You have unfollowed #{relationship.followed.fullname}"
      relationship.destroy      
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = "Not allowed to do that."
    end
    redirect_to people_url
  end

end