require 'spec_helper'

describe Relationship do
  it { is_expected.to belong_to(:follower).class_name("User") }
  it { is_expected.to belong_to(:leader).class_name("User") }
  it { is_expected.to validate_uniqueness_of(:leader_id).scoped_to(:follower_id) }
end
