module Fastlane
  module Actions
    module SharedValues
      GIT_GET_REMOTE_INFO_URL = :GIT_GET_REMOTE_INFO_URL
      GIT_GET_REMOTE_INFO_HOST = :GIT_GET_REMOTE_INFO_HOST
      GIT_GET_REMOTE_INFO_PATH = :GIT_GET_REMOTE_INFO_PATH
      GIT_GET_REMOTE_INFO_USER = :GIT_GET_REMOTE_INFO_USER
      GIT_GET_REMOTE_INFO_PASSWORD = :GIT_GET_REMOTE_INFO_PASSWORD
    end

    class GitGetRemoteInfoAction < Action
      def self.run(params)
        remote = params[:remote]
        if git_url = Actions.sh("git config --get remote.#{remote}.url")
          git_url = git_url.chomp()
          output = {}
          if git_url.start_with?("https")
            self.https_parser(git_url, output)
          else
            self.ssh_parser(git_url, output)
          end
          Actions.lane_context[SharedValues::GIT_GET_REMOTE_INFO_URL] = output[:url]
          Actions.lane_context[SharedValues::GIT_GET_REMOTE_INFO_HOST] = output[:host]
          Actions.lane_context[SharedValues::GIT_GET_REMOTE_INFO_PATH] = output[:path]
          Actions.lane_context[SharedValues::GIT_GET_REMOTE_INFO_USER] = output[:user]
          Actions.lane_context[SharedValues::GIT_GET_REMOTE_INFO_PASSWORD] = output[:password]
          return output
        end
        return nil
      end

      def self.ssh_parser(value, output)
        start_index = 0
        output[:url] = value
        if i = value.index("@")
          output[:user] = value.slice(start_index, i)
          start_index = i + 1
        end
        if i = value.index(":", start_index)
          output[:host] = value.slice(start_index, i - start_index)
          start_index = i + 1
        end
        if i = value.index(".git", start_index)
          output[:path] = value.slice(start_index, i - start_index)
          start_index = i + 1
        end
        return output
      end

      def self.https_parser(value, output)
        start_index = 8
        output[:url] = value
        if i = value.index("/", start_index)
          self.https_host_parser(value.slice(start_index, i - start_index), output)
          start_index = i + 1
        end
        if i = value.index(".git", start_index)
          output[:path] = value.slice(start_index, i - start_index)
          start_index = i + 1
        end
        return output
      end

      def self.https_host_parser(value, output)
        start_index = 0
        if i = value.index("@")
          self.https_auth_parser(value.slice(start_index, i - start_index), output)
          start_index = i + 1
        end
        output[:host] = value.slice(start_index, value.length - start_index)
      end

      def self.https_auth_parser(value, output)
        start_index = 0
        if i = value.index(":")
          output[:user] = value.slice(start_index, i - start_index)
          start_index = i + 1
          output[:password] = value.slice(start_index, value.length - start_index)
        else
          output[:user] = value
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Retrieves info about the remote of your git repository"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :remote,
                                       env_name: "GIT_GET_REMOTE_INFO_REMOTE",
                                       description: "The name of the remote",
                                       default_value: "origin")
        ]
      end

      def self.output
        [
          ['GIT_GET_REMOTE_INFO_URL', 'The remote URL of your git repository'],
          ['GIT_GET_REMOTE_INFO_HOST', 'The host part of the remote URL'],
          ['GIT_GET_REMOTE_INFO_PATH', 'The path part of the remote URL'],
          ['GIT_GET_REMOTE_INFO_USER', 'The user part of the remote URL'],
          ['GIT_GET_REMOTE_INFO_PASSWORD', 'The password part of the remote URL']
        ]
      end

      def self.return_value
        "Hash with info about the remote of your git repository"
      end

      def self.authors
        ["bbriatte"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'git_get_remote_info'
        ]
      end

      def self.category
        :source_control
      end
    end
  end
end
