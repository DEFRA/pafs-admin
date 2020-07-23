# frozen_string_literal: true

module ProjectFailures
  module Notification
    class Failure < Base
      def email
        @email ||= PolIntegrationMailer.failure_notification(report)
      end
    end
  end
end
