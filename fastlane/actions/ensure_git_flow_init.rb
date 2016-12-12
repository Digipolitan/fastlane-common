module Fastlane
  module Actions
    module SharedValues
    end

    class EnsureGitFlowInitAction < Action

      def self.run(params)
        begin
          Actions.sh("git config --get-regexp gitflow")
          UI.success "Git flow initialized"
        rescue
          UI.user_error! "Git flow is not initialized, you must call 'git flow init' in your project directory"
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Ensure git flow init was called"
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

    end
  end
end
