# frozen_string_literal: true

class ResetExpiredProjectEndFinancialYearService < PafsCore::BaseService

  include PafsCore::FinancialYear

  def run
    projects_expired = expired_projects
    Rails.logger.info "Number of projects with expired project end FY - #{projects_expired.count}"

    projects_expired.each do |project|
      project.update(project_end_financial_year: current_financial_year)
    end
  end

  private

  def expired_projects
    PafsCore::Project.joins(:state)
                     .where(pafs_core_states: { state: %i[draft archived] })
                     .where(project_end_financial_year: ...current_financial_year)
                     .limit(500)
  end
end
