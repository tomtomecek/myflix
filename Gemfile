source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails',          '4.1.1'
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'bcrypt',         '~> 3.1.7'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'hirb'
  gem 'quiet_assets'
  gem 'letter_opener'
end

group :development, :test do
  gem 'faker'
  gem 'fabrication'
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
end

group :production do
  gem 'rails_12factor'
end