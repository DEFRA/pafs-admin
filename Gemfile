# frozen_string_literal: true
source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 4.2.11.1"

# Use postgresql as the database for Active Record
gem "pg", "~> 0.20.0"

# rake 11 can break stuff see: http://stackoverflow.com/questions/35893584/nomethoderror-undefined-method-last-comment-after-upgrading-to-rake-11/35893941
gem "rake", "< 11.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.1.0"
gem "therubyracer", platforms: :ruby
gem "font-awesome-sass", "~> 4.5.0"
gem "jquery-rails"
# gem "jquery-turbolinks"
# gem "turbolinks"
gem "jbuilder", "~> 2.0"
gem "sdoc", "~> 0.4.0", group: :doc

# Parsing PF Calculator
gem 'roo'

# pagination
gem "kaminari"

gem "dotenv-rails"
gem "devise",           "~> 4.6.1"
gem "devise_invitable", "~> 1.7.5"

# Provided by GDS - Template gives us a master layout into which
# we can inject our content using yield and content_for
gem "govuk_template", "~> 0.17.0"
gem "govuk_frontend_toolkit", "~> 4.10.0"
gem "govuk_elements_rails"

# active job backend
gem "sucker_punch", "~> 2.0"

# static pages
gem "passenger", "~> 5.0.25", require: false
gem "whenever", require: false

# shared PAFS code
gem "pafs_core", "~> 0.0",
  git: "https://github.com/DEFRA/pafs_core",
  branch: "develop"

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
  gem "web-console", "~> 2.0"
  gem "letter_opener"
  gem "spring"
  gem "overcommit"
end

group :test do
  gem "factory_bot_rails"
  gem "shoulda-matchers", "~> 3.1"
  gem "faker"
  gem "capybara"
  gem "database_cleaner"
  gem "simplecov", require: false
  gem "codeclimate-test-reporter", "~> 0.6", require: false
  gem "webmock"
end

group :production, :edge, :qa, :staging do
  gem "rails_12factor"
  gem "airbrake", "~> 5.0"
end

group :benchmark do
  gem "benchmark-ips"
  gem "ruby-prof"
  gem "stackprof"
  gem "rbtrace"
end
