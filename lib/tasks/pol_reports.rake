# frozen_string_literal: true

namespace :admin do
  task send_success_report: :environment do
    report = ProjectsSentToPol::Report::Success.new
    abort 'No successes to notify about' if report.empty?

    ProjectFailures::Notification::Success.perform(report)
  end

  task send_failure_report: :environment do
    report = ProjectsSentToPol::Report::Success.new
    abort 'No failures to notify about' if report.empty?

    ProjectsSentToPol::Notification::Failure.perform(report)
  end
end
