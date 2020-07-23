# frozen_string_literal: true

module ProjectFailures
  module Notification
    class Success < Base
      def email
        @email ||= PolIntegrationMailer.success_notification(report)
      end
    end
  end
end
