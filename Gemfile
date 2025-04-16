# frozen_string_literal: true

source "https://rubygems.org"

# Use postgresql as the database for Active Record
gem "pg"

gem "rake"
gem "sass-rails", "~> 5.1"
gem "uglifier"

gem "font-awesome-sass", "~> 5.15"
gem "jbuilder"
gem "jquery-rails"
gem "sdoc"
gem "spreadsheet", "~> 1.3"
gem "to_xls", "~> 1.5", ">= 1.5.3"

gem "net-imap"
gem "net-pop"
gem "net-smtp"

# Pin psych version to avoid GitHub CI failures on v5+: https://github.com/ruby/setup-ruby/issues/409
gem "psych", "~> 4"

# Parsing PF Calculator
gem "roo"

# pagination
gem "kaminari"

gem "devise"
gem "devise_invitable"
gem "devise-security"
gem "dotenv-rails"

# GOV.UK styling
gem "defra_ruby_template"
gem "govuk_design_system_formbuilder"

# active job backend
gem "sucker_punch", "~> 3.1"

# static pages
gem "passenger", require: false
gem "whenever", require: false

# shared PAFS code
gem "pafs_core", "~> 0.0",
    github: "DEFRA/pafs_core",
    branch: "main",
    glob: "pafs_core.gemspec"

gem "dibble", "~> 0.1",
    git: "https://github.com/tonyheadford/dibble",
    branch: "develop"

gem "nokogiri"

gem "github_changelog_generator"

group :development, :test do
  gem "byebug"
  gem "climate_control"
  gem "defra_ruby_style"
  gem "pry"
  gem "rspec-rails"
  gem "rubocop"
  gem "rubocop-capybara"
  gem "rubocop-rails"
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "rubocop-rspec_rails"
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

group :benchmark do
  gem "benchmark-ips"
  gem "rbtrace"
  gem "ruby-prof"
  gem "stackprof"
end
