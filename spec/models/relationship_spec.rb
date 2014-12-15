require 'spec_helper'

describe Relationship do

  it { should belong_to(:follower).class_name("User") }
  it { should belong_to(:followed).class_name("User") }
  it { should validate_uniqueness_of(:followed_id).scoped_to(:follower_id) }
  
end