# frozen_string_literal: true

require File.expand_path("boot", __dir__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PafsAdmin
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.load_defaults 5.0

    # load decorators
    config.to_prepare do
      Rails.root.glob("app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end

      Rails.root.glob("lib/projects_sent_to_pol/**/*.rb").each do |c|
        require_dependency(c)
      end
    end

    config.active_job.queue_adapter = :sucker_punch
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # exception handling
    config.exceptions_app = routes

    logger           = ActiveSupport::Logger.new(Rails.root.join("log", "#{Rails.env}.log"))
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)  
  end
end
