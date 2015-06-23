require 'elasticsearch/rails/tasks/import'

# https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-rails
#
# bundle exec rake environment elasticsearch:import:model CLASS='Video' SCOPE='published'