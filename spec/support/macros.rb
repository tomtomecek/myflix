def set_current_user(user=nil)
  user = user || Fabricate(:user)
  session[:user_id] = user.id
end

def set_current_admin(admin=nil)
  admin = admin || Fabricate(:admin)
  session[:user_id] = admin.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end
alias :clear_current_admin :clear_current_user