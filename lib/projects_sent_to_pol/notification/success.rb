# frozen_string_literal: true

require_relative "base"

module ProjectsSentToPol
  module Notification
    class Success < Base
      def email
        @email ||= PolIntegrationMailer.success_notification(report)
      end
    end
  end
end
