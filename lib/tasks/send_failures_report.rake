# frozen_string_literal: true

namespace :admin do
  task send_failure_report: :environment do
    report = ProjectFailures::Report.new
    abort 'No failures to notify about' if report.empty?

    ProjectFailures::Notification.perform(report)
  end
end
