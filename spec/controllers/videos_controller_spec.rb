require 'spec_helper'

describe VideosController do
  
  describe "GET show" do
    it "sets the @video variable" do
      interstellar = Video.create(title: "Interstellar", description: "a big step for humans.")
      
      get :show, id: interstellar
      expect(assigns(:video)).to eq(interstellar)
    end

    it "renders the show template" do
      interstellar = Video.create(title: "Interstellar", description: "a big step for humans.")
      
      get :show, id: interstellar
      expect(response).to render_template :show
    end
  end

  describe "GET search" do
    it "sets the @result variable" do
      interstellar = Video.create(title: "Interstellar", description: "a big step for humans.")
      
      get :search, query: "Interstellar"
      expect(assigns(:result)).to eq([interstellar])
    end

    it "renders the search template" do
      interstellar = Video.create(title: "Interstellar", description: "a big step for humans.")
      
      get :search
      expect(response).to render_template :search
    end

  end

end