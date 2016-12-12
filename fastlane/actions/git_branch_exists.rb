module Fastlane
  module Actions
    module SharedValues
    end

    class GitBranchExistsAction < Action
      def self.run(params)
        begin
          branch = params[:branch]
          Actions.sh("git branch | grep -w #{branch}", log: false)
          return true
        rescue
          return false
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Return true if the given branch exists, otherwise false"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :branch,
                                       description: "The branch name to check",
                                       optional: false)
        ]
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
          'git_branch_exists(
            branch: "beta"
          )'
        ]
      end
    end
  end
end
