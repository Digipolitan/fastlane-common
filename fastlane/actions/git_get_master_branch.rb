module Fastlane
  module Actions
    module SharedValues
      GIT_MASTER_BRANCH = :GIT_MASTER_BRANCH
    end

    class GitGetMasterBranchAction < Action

      def self.run(params)
        branch = nil
        begin
          branch = Actions.sh("git config --get gitflow.branch.master", log: false).strip()
        rescue
          branch = "master"
        end
        Actions.lane_context[SharedValues::GIT_MASTER_BRANCH] = branch
        return branch
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Get the git master branch"
      end

      def self.authors
        ["bbriatte"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.category
        :source_control
      end

      def self.example_code
        [
          'git_get_master_branch'
        ]
      end
    end
  end
end
