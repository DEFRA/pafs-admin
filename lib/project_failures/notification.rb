# frozen_string_literal: true

module ProjectFailures
  class Notification
    attr_reader :report

    def initialize(report)
      @report = report
    end

    def self.perform(report)
      new(report).tap(&:perform)
    end

    def perform
      email.deliver_now
    end

    def email
      @email ||= SendFailureMailer.notification(report)
    end
  end
end
