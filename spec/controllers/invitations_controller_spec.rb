require 'spec_helper'

describe InvitationsController do

  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
    
    it "sets the @invitation" do
    end
  end
end