# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", ">= 6.0", "< 6.1"

# Use postgresql as the database for Active Record
gem "pg", "~> 0.20.0"

gem "rake"
gem "sass-rails", "~> 5.0"
gem "uglifier"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails"
gem "therubyracer", platforms: :ruby
gem "font-awesome-sass", "~> 4.5.0"
gem "jquery-rails"
# gem "jquery-turbolinks"
# gem "turbolinks"
gem "jbuilder"
gem "sdoc"

# Parsing PF Calculator
gem 'roo'

# pagination
gem "kaminari"

gem "dotenv-rails"
gem "devise",           "~> 4.7.1"
gem "devise_invitable", "~> 2.0"
gem "devise-security"

# Provided by GDS - Template gives us a master layout into which
# we can inject our content using yield and content_for
gem "govuk_template", "0.26.0"
gem "govuk_frontend_toolkit", "~> 9.0.0"
gem "govuk_elements_rails"
gem "govuk_publishing_components"

# active job backend
gem "sucker_punch", "~> 2.0"

# static pages
gem "passenger", "~> 5.0.25", require: false
gem "whenever", require: false

# shared PAFS code
gem "pafs_core", "~> 0.0",
  git: "https://github.com/DEFRA/pafs_core",
  branch: "fix/airbrake"

gem "dibble", "~> 0.1",
  git: "https://github.com/tonyheadford/dibble",
  branch: "develop"

group :development, :test do
  gem "rspec-rails"
  gem "byebug"
  gem "pry"
  gem "guard-rspec", require: false
  gem "climate_control"
end

group :development do
  gem "web-console"
  gem "letter_opener"
  gem "spring"
  gem "overcommit"
end

group :test do
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "faker"
  gem "capybara"
  gem 'capybara-webmock'
  gem "poltergeist"
  gem "database_cleaner"
  gem "simplecov", require: false
  gem "codeclimate-test-reporter", require: false
  gem "webmock"
end

group :production, :edge, :qa, :staging do
  gem "rails_12factor"
end

group :benchmark do
  gem "benchmark-ips"
  gem "ruby-prof"
  gem "stackprof"
  gem "rbtrace"
end
