# frozen_string_literal: true

namespace :one_off do
  desc "Set listed draft project as submitted"
  task set_listed_projects_as_submitted: :environment do

    project_references = %w[ACC501E/000A/034A ACC501E/000A/080A AEC501E/000A/228A AEC501E/000A/260A SNC001E/000A/050A
                            SNC500E/000A/079A SNC501E/000A/319A SOC501E/000A/040A SOC501E/000A/111A SWC012F/000A/064A
                            THC501E/000A/073A THC501E/000A/169A YOC501E/000A/341A YOC501E/000A/473A YOC501E/000A/490A
                            ACC501E/000A/124A ACC501E/000A/134A AEC501E/000A/017A ANC501E/000A/237A ANC501E/000A/257A
                            NWC013F/000A/001A NWC501E/000A/444A NWC501E/000A/704A NWC501E/000A/710A NWC501E/000A/733A
                            NWC501E/000A/735A SNC501E/000A/103A SNC501E/000A/318A SOC501E/000A/003A SOC501E/000A/107A
                            SOC501E/000A/158A SOC501E/000A/162A SWC501E/000A/232A SWC501E/000A/249A SWC501E/000A/262A
                            SWC501E/000A/264A THC501E/000A/282A THC501E/000A/307A THC501E/000A/331A THC501E/000A/347A
                            WXC005F/000A/162A WXC501E/000A/073A WXC501E/000A/075A YOC356F/000A/057A YOC357I/000A/042A
                            YOC357I/000A/052A YOC501E/000A/091A YOC501E/000A/521A YOC501E/000A/529A YOC501E/000A/530A
                            YOC501E/000A/537A]

    project_references.each do |project_ref|
      project = PafsCore::Project.find_by(reference_number: project_ref)
      next unless project

      # Check if the project is draft
      if project.state.state != "draft"
        puts "Project #{project_ref} is not in draft state. Skipping..."
        next
      end

      PafsCore::Projects::StatusUpdate.new(project, "submitted").perform
    end
  end
end
