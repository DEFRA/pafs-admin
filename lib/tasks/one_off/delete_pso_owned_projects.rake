# frozen_string_literal: true

namespace :one_off do
  desc "Delete all PSO-owned projects"
  task delete_pso_owned_projects: :environment do
    pso_areas = PafsCore::Area.where(area_type: PafsCore::Area::PSO_AREA)
    pso_area_projects = PafsCore::AreaProject.where(area_id: pso_areas.pluck(:id))
    pso_projects = PafsCore::Project.where(id: pso_area_projects.pluck(:project_id))

    # Deleting one at a time instead of using destroy_all
    # because of the requirement to report project names
    pso_projects.each do |project|
      project.destroy!
      puts "Deleted project #{project.reference_number}"
    rescue StandardError => e
      puts "Error deleting project #{project.reference_number}: #{e}"
    end
  end
end
