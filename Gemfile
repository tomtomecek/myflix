source 'https://rubygems.org'
ruby '2.1.1'

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

group :development do
  gem 'thin'
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'hirb'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'spring-commands-rspec'
  gem 'faker'
  gem 'fabrication'
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
end

group :production do
  gem 'rails_12factor'
end