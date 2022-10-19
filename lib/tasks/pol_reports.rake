# frozen_string_literal: true

namespace :admin do

  desc "Send POL projects sent success report"
  task send_success_report: :environment do
    report = ProjectsSentToPol::Report::Success.new
    abort "No successes to notify about" if report.empty?

    ProjectsSentToPol::Notification::Success.perform(report)
  end

  desc "Send POL projects sent failure report"
  task send_failure_report: :environment do
    report = ProjectsSentToPol::Report::Failure.new
    abort "No failures to notify about" if report.empty?

    ProjectsSentToPol::Notification::Failure.perform(report)
  end
end
