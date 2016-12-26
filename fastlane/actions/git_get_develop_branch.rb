module Fastlane
  module Actions
    module SharedValues
      GIT_DEVELOP_BRANCH = :GIT_DEVELOP_BRANCH
    end

    class GitGetDevelopBranchAction < Action

      def self.run(params)
        branch = nil
        begin
          branch = Actions.sh("git config --get gitflow.branch.develop", log: false).strip()
        rescue
          branch = "develop"
        end
        Actions.lane_context[SharedValues::GIT_DEVELOP_BRANCH] = branch
        return branch
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Get the git develop branch"
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
          'git_get_develop_branch'
        ]
      end
    end
  end
end
