# frozen_string_literal: true

namespace :one_off do
  desc "Reset expired project end financial years (project_end_financial_year < current FY)"
  task reset_expired_project_end_financial_years: :environment do
    ResetExpiredProjectEndFinancialYearService.run
  end
end
