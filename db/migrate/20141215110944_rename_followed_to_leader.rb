class RenameFollowedToLeader < ActiveRecord::Migration
  def change
    rename_column :relationships, :followed_id, :leader_id
  end
end
