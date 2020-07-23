# frozen_string_literal: true

describe ProjectsSentToPol::Notification::Success do
  let(:email) { double(:email) }
  let(:report) { double(:report) }

  before do
    allow(PolIntegrationMailer).to receive(:success_notification).with(report).and_return(email)
  end

  context 'when notifications are disabled' do
    around do |example|
      with_modified_env POL_FAILURE_NOTIFICATION_EMAIL: '' do
        example.run
      end
    end

    it 'does not send a notification' do
      expect(email).to_not receive(:deliver_now)
      described_class.perform(report)
    end
  end

  context 'when notifications are enabled' do
    around do |example|
      with_modified_env POL_FAILURE_NOTIFICATION_EMAIL: 'test@example.com' do
        example.run
      end
    end

    it 'sends the email' do
      expect(email).to receive(:deliver_now)
      described_class.perform(report)
    end
  end
end
