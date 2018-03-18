require 'spec_helper'

describe Admin::PaymentsController do
  describe "GET index" do
    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end

    it_behaves_like "require admin" do
      let(:action) { get :index }
    end

    it "sets the @payments" do
      p1 = Fabricate(:payment)
      p2 = Fabricate(:payment)
      set_current_admin
      get :index
      expect(assigns(:payments)).to match_array([p1, p2])
    end
  end
end
