# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 6.1"

# Use postgresql as the database for Active Record
gem "pg"

gem "rake"
gem "sass-rails", "~> 6.0"
gem "uglifier"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails"
gem "font-awesome-sass", "~> 4.4"
gem "jbuilder"
gem "jquery-rails"
gem "mini_racer", "~> 0.6"
gem "sdoc"
gem "spreadsheet", "~> 1.3"
gem "to_xls", "~> 1.5", ">= 1.5.3"

# Parsing PF Calculator
gem "roo"

# pagination
gem "kaminari"

gem "devise",           "~> 4.8"
gem "devise_invitable", "~> 2.0"
gem "devise-security"
gem "dotenv-rails"

gem "govuk_elements_rails"
gem "govuk_frontend_toolkit", "~> 9.0.0"
gem "govuk_publishing_components", "~> 31.1.1"
gem "govuk_template", "0.26.0"

# active job backend
gem "sucker_punch", "~> 3.1"

# static pages
gem "passenger", "~> 5.1.0", require: false
gem "whenever", require: false

# shared PAFS code
gem "pafs_core", "~> 0.0",
    git: "https://github.com/DEFRA/pafs_core",
    branch: "main"

gem "dibble", "~> 0.1",
    git: "https://github.com/tonyheadford/dibble",
    branch: "develop"

group :development, :test do
  gem "byebug"
  gem "climate_control"
  gem "defra_ruby_style", "~> 0.3"
  gem "pry"
  gem "rspec-rails"
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rake"
  gem "rubocop-rspec"
end

group :development do
  gem "letter_opener"
  gem "spring"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "capybara-webmock"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "faker"
  gem "poltergeist"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "webmock"
end

group :production, :edge, :qa, :staging do
  gem "rails_12factor"
end

group :benchmark do
  gem "benchmark-ips"
  gem "rbtrace"
  gem "ruby-prof"
  gem "stackprof"
end
