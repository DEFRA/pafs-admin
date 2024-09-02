# frozen_string_literal: true

namespace :one_off do
  desc "Remove unnecessery PFCs from draft and archived projects of not DEF or CM type"
  task remove_unnecessery_pfcs: :environment do

    include PafsCore::Files

    projects = PafsCore::Project.where.not(project_type: %w[DEF CM])
                                .joins(:state).where(state: { state: %w[draft archived] })
    projects.each do |project|
      next if project.funding_calculator_file_name.blank?

      delete_funding_calculator_for(project)
      puts "Removed PFCs from project #{project.reference_number}"
    rescue StandardError => e
      puts "Error removing PFCs from project #{project.reference_number}: #{e}"
    end
  end
end
