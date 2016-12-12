module Fastlane
  module Actions
    module SharedValues
    end

    class GitFlowInitAction < Action

      def self.isInit()
        res = Actions.sh("git config --get-regexp gitflow", log: false).chomp()
        return res.length > 0
      end

      def self.init(master_branch, develop_branch, prefix_feature, prefix_bugfix, prefix_release, prefix_hotfix, prefix_support, prefix_versiontag)
        UI.message "Starting git flow init..."
        file_name = ".gitflow_init.tmp"
        Actions.sh("rm -f #{file_name}", log: false)
        Actions.sh("echo '#!/usr/bin/expect' >> #{file_name}", log: false)
        Actions.sh("echo 'spawn git flow init' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Master branch:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{master_branch}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Develop branch:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{develop_branch}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Prefix feature:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{prefix_feature}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Prefix Bugfix:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{prefix_bugfix}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Prefix Release:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{prefix_release}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Prefix Hotfix:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{prefix_hotfix}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Prefix Support:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{prefix_support}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Prefix Versiontag:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{prefix_versiontag}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Hook path:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect eof' >> #{file_name}", log: false)
        Actions.sh("expect -f #{file_name}", log: false)
        Actions.sh("rm -f #{file_name}", log: false)
      end

      def self.run(params)
        if !self.isInit()
          self.init(
            params[:master_branch],
            params[:develop_branch],
            params[:prefix_feature],
            params[:prefix_bugfix],
            params[:prefix_release],
            params[:prefix_hotfix],
            params[:prefix_support]
            params[:prefix_versiontag]
          )
        end
        UI.success "Git flow successfully init"
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
          FastlaneCore::ConfigItem.new(key: :prefix_support,
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
