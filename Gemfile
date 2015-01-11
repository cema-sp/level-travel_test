source 'https://rubygems.org'
# source 'http://rails-assets.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# gem 'rails-assets-semantic-ui-1.0', source: 'http://rails-assets.org'
gem 'semantic-ui-sass', github: 'doabit/semantic-ui-sass', branch: 'v1.0beta'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin]

# HTTP requests
gem 'typhoeus'

# Background workers
gem 'sidekiq'

# Markdown processing
gem 'kramdown'

group :development do
  # better IRB and better print
  gem 'pry'
  gem 'awesome_print'
  # end

  # better errors display
  gem 'better_errors'
  gem 'binding_of_caller'
  # end

  # turn off assets messages
  gem 'quiet_assets'
  # end

  # rubocop for code style
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  # end
end

group :development, :test do
  # RSpec
  gem 'rspec-rails', '~> 3.0.0'
  gem 'rspec-its'
  gem 'rspec-expectations', '~> 3.0.0'
  # end

  gem 'webmock'

  # colorful output
  gem 'colorize'
  # end

  # Use sqlite3 as the database for Active Record
  # gem 'sqlite3'
end

group :test do
  gem 'database_cleaner'

  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'cucumber-rails', require: false
  # gem 'factory_girl_rails', require: false
  # gem 'faker'

  # Rake used by Travis-ci
  gem 'rake'
  # Code coverage
  gem 'simplecov', require: false
  gem 'coveralls', require: false
end

group :production do
  # gem 'pg'
  # gem 'rails_12factor'

  # Unicorn application server
  gem 'unicorn'
end
