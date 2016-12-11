module Fastlane
  module Actions
    module SharedValues
    end

    class GitFlowInitAction < Action

      def self.isInit()
        res = Actions.sh("git config --get-regexp gitflow", log: false).chomp()
        return res.length > 0
      end

      def self.run(params)
        if !self.isInit()
          res = Actions.sh("git flow init -d")
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "git flow init action"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :master_branch,
                                       env_name: "GIT_FLOW_MASTER_BRANCH",
                                       description: "The name of the master branch for git flow",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :develop_branch,
                                       env_name: "GIT_FLOW_DEVELOP_BRANCH",
                                       description: "The name of the develop branch for git flow",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :prefix_feature,
                                       env_name: "GIT_FLOW_PREFIX_FEATURE",
                                       description: "The name of the feature for git flow",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :prefix_bugfix,
                                       env_name: "GIT_FLOW_PREFIX_BUGFIX",
                                       description: "The name of the bugfix for git flow",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :prefix_release,
                                       env_name: "GIT_FLOW_PREFIX_RELEASE",
                                       description: "The name of the release for git flow",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :prefix_hotfix,
                                       env_name: "GIT_FLOW_PREFIX_HOTFIX",
                                       description: "The name of the hotfix for git flow",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :prefix_release,
                                       env_name: "GIT_FLOW_PREFIX_SUPPORT",
                                       description: "The name of the support for git flow",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :prefix_versiontag,
                                       env_name: "GIT_FLOW_PREFIX_VERSIONTAG",
                                       description: "The prefix versiontag use by git flow",
                                       default_value: "v")
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

    end
  end
end
