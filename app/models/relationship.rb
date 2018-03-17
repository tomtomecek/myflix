class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :leader, class_name: "User"

  validates_uniqueness_of :leader_id, scope: :follower_id
end
