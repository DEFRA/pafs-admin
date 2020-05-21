# frozen_string_literal: true

class AllFcrmGenerationMailer < ApplicationMailer
  include PafsCore::Email

  def success(user)
    prevent_tracking
    mail(to: user.email, subject: "Your requested report is ready")
  end

  def failure(user)
    prevent_tracking
    mail(to: user.email, subject: "Your report failed to complete")
  end

  private

  def default_url_options
    {
      host: ENV.fetch('DEFAULT_URL_HOST_BACKOFFICE', 'example.com')
    }
  end
end
