require 'spec_helper'

describe Payment do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:charge_id) }
end
