# frozen_string_literal: true

namespace :admin do
  task send_failure_report: :environment do
    report = ProjectFailures::Report.new
    return if report.empty?

    ProjectFailures::Notification.perform(report)
  end
end
