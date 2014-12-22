class RelationshipsController < AuthenticatedController

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    Relationship.create(follower: current_user, leader: leader) if current_user.can_follow?(leader)

    redirect_to people_url
  end

  def destroy
    relationship = Relationship.find(params[:id])
    flash[:info] = "You have unfollowed #{relationship.leader.fullname}"
    relationship.destroy if current_user == relationship.follower
    
    redirect_to people_url
  end

end