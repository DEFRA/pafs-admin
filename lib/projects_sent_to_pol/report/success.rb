# frozen_string_literal: true

module ProjectsSentToPol
  module Report
    class Success
      delegate :empty?, :size, to: :projects

      def projects
        @projects ||= PafsCore::Project.submitted.where(
          submitted_to_pol: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day
        )
      end
    end
  end
end
