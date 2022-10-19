# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper PafsCore::EmailHelper
  default from: ENV.fetch("DEVISE_MAILER_SENDER")
  layout "mailer"
end
