def set_current_user(user = nil)
  user ||= Fabricate(:user)
  session[:user_id] = user.id
end

def set_current_admin(admin = nil)
  admin ||= Fabricate(:admin)
  session[:user_id] = admin.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end
alias :clear_current_admin :clear_current_user

def get_stripe_token
  Stripe.api_key = ENV['STRIPE_API_KEY']

  token = Stripe::Token.create(
    card: {
      number: '4242424242424242',
      exp_month: 12,
      exp_year: 2015,
      cvc: '314'
    },
  )
  token.id
end

def snap!(options = {})
  path = options.fetch :path, "~/.Trash"
  file = options.fetch :file, "#{Time.now.to_i}.png"
  full = options.fetch :full, true

  path = File.expand_path path
  path = "/tmp" if !File.exists?(path)

  uri = File.join path, file

  page.driver.render uri, full: full
  system "open #{uri}"
end
