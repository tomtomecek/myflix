require 'raven'

Raven.configure do |config|
  config.dsn = ENV['sentry_dsn']
end