require 'spec_helper'

describe UsersController do

  describe "GET new" do
    let(:user) { Fabricate.build(:user) }
    it "sets the @user variable" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "creates the user if record is valid" do
      before { post :create, user: Fabricate.attributes_for(:user) }
    
      it { expect(User.count).to eq(1) }
      it { expect(response).to redirect_to sign_in_url }
    end

    context "does not create the user if record is invalid" do
      before { post :create, user: { email: "" } }

      it { expect(response).to render_template :new }
      it { expect(assigns(:user).errors.any?).to be true }
    end
  end
  
end