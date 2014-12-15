require 'spec_helper'

describe Relationship do

  it { should belong_to(:follower).class_name("User") }
  it { should belong_to(:leader).class_name("User") }
  it { should validate_uniqueness_of(:leader_id).scoped_to(:follower_id) }
  
end