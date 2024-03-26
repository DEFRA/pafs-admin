# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin", type: :rake do

  before do
    task.reenable
  end

  describe "admin:send_success_report", type: :rake do
    let(:task) { Rake::Task["admin:send_success_report"] }

    it "triggers ProjectsSentToPol::Notification::Success task" do
      create(:project, :submitted, submitted_to_pol: 1.day.ago)

      allow(ProjectsSentToPol::Notification::Success).to receive(:perform)
      expect { task.invoke }.not_to raise_error
      expect(ProjectsSentToPol::Notification::Success).to have_received(:perform)
    end
  end

  describe "admin:send_failure_report", type: :rake do
    let(:task) { Rake::Task["admin:send_failure_report"] }

    it "triggers ProjectsSentToPol::Notification::Failure task" do
      create(:project, :submitted, submitted_to_pol: nil)

      allow(ProjectsSentToPol::Notification::Failure).to receive(:perform)
      expect { task.invoke }.not_to raise_error
      expect(ProjectsSentToPol::Notification::Failure).to have_received(:perform)
    end
  end
end
