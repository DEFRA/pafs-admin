# frozen_string_literal: true

require_relative "./base"

module ProjectsSentToPol
  module Notification
    class Failure < Base
      def email
        @email ||= PolIntegrationMailer.failure_notification(report)
      end
    end
  end
end
