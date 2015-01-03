require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "registers successfully" do
      let(:registration) { double("registration", successfull?: true) }
      before do
        UserRegistration.any_instance.should_receive(:register).and_return(registration)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
      end

      it { is_expected.to redirect_to sign_in_url }
      it { is_expected.to set_the_flash[:success] }
    end

    context "registration fails" do
      let(:registration) { double("registration", successfull?: false, charging_error_message: "Your card was declined") }
      before do
        UserRegistration.any_instance.should_receive(:register).and_return(registration)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
      end

      it { is_expected.to render_template :new }
      it { is_expected.to set_the_flash.now[:danger] }
    end
  end

  describe "GET show" do
    it "sets the @user" do
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end