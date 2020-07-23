# frozen_string_literal: true

module ProjectsSentToPol
  module Report
    class Failure
      delegate :empty?, :size, to: :projects

      def projects
        @projects ||= PafsCore::Project.submitted.where(submitted_to_pol: nil)
      end
    end
  end
end
