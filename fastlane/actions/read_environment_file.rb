module Fastlane
  module Actions
    module SharedValues
    end

    class ReadEnvironmentFileAction < Action
      def self.run(params)
        if data = File.read(params[:path])
          variables = {}
          if lines = data.split("\n")
            lines.each { |line|
              if index = line.index('=')
                variables[line[0..index-1]] = line[index+1..line.length]
              end
            }
          end
          return variables
        end
        return nil
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Read and parse the given file"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path,
                                       description: "The environment file path to read",
                                       optional: false)
        ]
      end

      def self.return_value
        "Returns an hash containing the environment parsed"
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
          'data = read_environment_file(path: ".env.Test")',
        ]
      end
    end
  end
end
