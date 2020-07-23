# frozen_string_literal: true

module ProjectsSentToPol
  module Notification
    class Base
      attr_reader :report

      def initialize(report)
        @report = report
      end

      def self.perform(report)
        new(report).tap(&:perform)
      end

      def enabled?
        !ENV.fetch('POL_FAILURE_NOTIFICATION_EMAIL', nil).blank?
      end

      def perform
        return unless enabled?

        email.deliver_now
      end

      def email
        raise("Override #email")
      end
    end
  end
end
