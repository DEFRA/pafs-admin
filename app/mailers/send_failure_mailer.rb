# frozen_string_literal: true

class SendFailureMailer < ApplicationMailer
  include PafsCore::Email

  def notification(report)
    @report = report
    prevent_tracking
    mail(to: admin_email, subject: "Projects pending submission to PoL")
  end

  private

  def admin_email
    ENV.fetch('POL_FAILURE_NOTIFICATION_EMAIL')
  end

  def default_url_options
    {
      host: ENV.fetch('DEFAULT_URL_HOST_BACKOFFICE', 'example.com')
    }
  end
end
