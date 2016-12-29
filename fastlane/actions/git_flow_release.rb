module Fastlane
  module Actions
    module SharedValues
    end

    class GitFlowReleaseAction < Action
      def self.run(params)
        action = params[:action]
        cmd = ["git flow release"]
        cmd << action
        if action == "start"
          cmd << "-F" if params[:fetch]
        elsif action == "finish"
          cmd << "-F" if params[:fetch]
          if message = params[:message]
            fix_message = message.downcase.split(' ').join('_') # fix git flow bug with spaces
            cmd << "-m '#{fix_message}'"
          end
          cmd << "-p" if params[:push]
          cmd << "-k" if params[:keep]
          cmd << "-n" unless params[:tag]
          cmd << "-S" if params[:squash]
        end
        cmd << params[:name]
        Actions.sh(cmd.join(" "))
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Git flow release implementation"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :action,
                                       env_name: "GIT_FLOW_RELEASE_ACTION",
                                       description: "The git-flow action to execute (start, finish, publish, track)",
                                       optional: false,
                                       verify_block: proc do |value|
                                         if value != "start" && value != "finish" && value != "publish" && value != "pull"
                                          UI.user_error! "Wrong git-flow action '#{value}', only 'start', 'finish', 'publish' and 'pull' are available."
                                        end
                                       end),
          FastlaneCore::ConfigItem.new(key: :name,
                                       env_name: "GIT_FLOW_NAME",
                                       description: "keep branch after performing finish",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :fetch,
                                       env_name: "GIT_FLOW_FETCH",
                                       description: "Fetch from $ORIGIN before performing local operation",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :message,
                                       env_name: "GIT_FLOW_RELEASE_MESSAGE",
                                       description: "Use the given tag message"),
          FastlaneCore::ConfigItem.new(key: :push,
                                       description: "push to $ORIGIN after performing finish",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :keep,
                                       description: "Keep branch after performing finish",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :tag,
                                       description: "Tag this release",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :squash,
                                       description: "Squash release during merge",
                                       is_string: false,
                                       default_value: false)
        ]
      end

      def self.authors
        ["bbriatte"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'git_flow_release(
            action: "start",
            name: "1.0.1"
          )',
          'git_flow_release(
            action: "finish",
            name: "1.0.1",
            "message": "New release version !"
          )'
        ]
      end

      def self.category
        :source_control
      end
    end
  end
end
