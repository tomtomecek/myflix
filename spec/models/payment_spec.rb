require 'spec_helper'

describe Payment do
  it { is_expected.to belong_to(:user) }
end