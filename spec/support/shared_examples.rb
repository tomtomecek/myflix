shared_examples "require sign in" do
  it "redirects to the front page" do
    clear_current_user
    action
    expect(response).to redirect_to root_url
  end
end

shared_examples "require admin" do
  it "redirects to the home page" do
    session[:user_id] = Fabricate(:user).id
    action
    expect(response).to redirect_to home_url
  end
end
