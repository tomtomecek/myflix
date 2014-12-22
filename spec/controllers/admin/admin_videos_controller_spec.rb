require 'spec_helper'

describe Admin::VideosController do

  describe "GET new" do
    it "sets the @video" do
      get :new
      expect(assigns(:video)).to be_instance_of Video
    end
    
  end
end