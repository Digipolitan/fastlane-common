module Fastlane
  module Actions
    module SharedValues
      GIT_FLOW_MASTER_BRANCH = :GIT_FLOW_MASTER_BRANCH
      GIT_FLOW_DEVELOP_BRANCH = :GIT_FLOW_DEVELOP_BRANCH
      GIT_FLOW_FEATURE_PREFIX = :GIT_FLOW_FEATURE_PREFIX
      GIT_FLOW_BUGFIX_PREFIX = :GIT_FLOW_BUGFIX_PREFIX
      GIT_FLOW_RELEASE_PREFIX = :GIT_FLOW_RELEASE_PREFIX
      GIT_FLOW_HOTFIX_PREFIX = :GIT_FLOW_HOTFIX_PREFIX
      GIT_FLOW_SUPPORT_PREFIX = :GIT_FLOW_SUPPORT_PREFIX
      GIT_FLOW_VERSIONTAG_PREFIX = :GIT_FLOW_VERSIONTAG_PREFIX
      GIT_FLOW_HOOKS_PATH = :GIT_FLOW_HOOKS_PATH
    end

    class EnsureGitFlowInitAction < Action

      @@git_flow_mapping = {
        "gitflow.branch.master" => SharedValues::GIT_FLOW_MASTER_BRANCH,
        "gitflow.branch.develop" => SharedValues::GIT_FLOW_DEVELOP_BRANCH,
        "gitflow.prefix.feature" => SharedValues::GIT_FLOW_FEATURE_PREFIX,
        "gitflow.prefix.bugfix" => SharedValues::GIT_FLOW_BUGFIX_PREFIX,
        "gitflow.prefix.release" => SharedValues::GIT_FLOW_RELEASE_PREFIX,
        "gitflow.prefix.hotfix" => SharedValues::GIT_FLOW_HOTFIX_PREFIX,
        "gitflow.prefix.support" => SharedValues::GIT_FLOW_SUPPORT_PREFIX,
        "gitflow.prefix.versiontag" => SharedValues::GIT_FLOW_VERSIONTAG_PREFIX,
        "gitflow.path.hooks" => SharedValues::GIT_FLOW_HOOKS_PATH
      }

      def self.run(params)
        config = nil
        begin
          config = Actions.sh("git config --get-regexp gitflow", log: false)
          UI.success "Git flow initialized"
        rescue
          UI.user_error! "Git flow is not initialized, you must call 'git flow init' in your project directory"
        end
        if lines = config.split("\n")
          lines.each do |line|
            if indexOf = line.index(" ")
              name = line[0, indexOf]
              maxIndexOf = indexOf + 1
              value = line[maxIndexOf, line.length - maxIndexOf]
              if lane_context = @@git_flow_mapping[name]
                Actions.lane_context[lane_context] = value
              end
            end
          end
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

      def self.example_code
        [
          'ensure_git_flow_init'
        ]
      end
    end
  end
end
