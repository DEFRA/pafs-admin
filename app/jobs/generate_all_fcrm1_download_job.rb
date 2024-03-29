# frozen_string_literal: true

class GenerateAllFcrm1DownloadJob < ApplicationJob
  def perform(user_id)
    ApplicationRecord.connection_pool.with_connection do

      user = PafsCore::User.find(user_id)
      PafsCore::Download::All.perform(user)

      # send notification email to requestor
      AllFcrmGenerationMailer.success(user).deliver_now
    rescue StandardError => e
      # send failure notification email
      AllFcrmGenerationMailer.failure(user).deliver_now
      Airbrake.notify(e) if defined? Airbrake
      raise e

    end
  end
end
