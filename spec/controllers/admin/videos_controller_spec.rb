require 'spec_helper'

describe Admin::VideosController do

  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    context "when regular user" do
      before do
        set_current_user
        get :new
      end

      it { is_expected.to redirect_to home_url }
      it { is_expected.to set_the_flash[:danger] }
    end

    context "when admin" do
      it "sets the @video" do
        set_current_admin
        get :new
        expect(assigns(:video)).to be_instance_of Video
        expect(assigns(:video)).to be_new_record
      end
    end

  end
end