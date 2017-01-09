module Fastlane
  module Actions
    module SharedValues
    end

    class GetEnvironmentsAction < Action
      def self.run(params)
        if envs = Dir[File.join(params[:directory_path], ".env.*")]
          env_hash = {}
          envs.each { |env_path|
            env_name = File.basename(env_path)[5..env_path.length]
            env_hash[env_name] = env_path
          }
          return env_hash
        end
        return nil
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Retrieves all environment variables from a directory"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :directory_path,
                                       env_name: "ENVIRONMENT_DIRECTORY_PATH",
                                       description: "The directory path to environments file",
                                       default_value: "fastlane")
        ]
      end

      def self.return_value
        "Returns an hash containing all specific environment informations"
      end

      def self.authors
        ["bbriatte"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.category
        :misc
      end

      def self.example_code
        [
          'envs = get_environments',
          'envs = get_environments(
            directory_path: "envs"
          )'
        ]
      end
    end
  end
end
