module Fastlane
  module Actions
    module SharedValues
    end

    class FilesMatchingAction < Action
      def self.run(params)
        files = Dir[File.join(params[:directory], params[:pattern])]
        if files != nil && files.length > 0
          if params[:basename] == true
            output = []
            files.each { |f|
              output.push(File.basename(f))
            }
            return output
          end
          return files
        end
        return nil
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Check if the given pattern match with a file inside the directory"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :pattern,
                                       description: "Search pattern",
                                       default_value: "*"),
          FastlaneCore::ConfigItem.new(key: :directory,
                                       description: "The directory where the pattern will be triggered",
                                       default_value: "."),
          FastlaneCore::ConfigItem.new(key: :basename,
                                      description: "Retrieves only the file basename when matching",
                                      is_string: false,
                                      default_value: true)
          ]
      end

      def self.return_value
        "Returns all files matching with the given pattern, otherwise nil if no file match with the given pattern"
      end

      def self.authors
        ["bbriatte"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'files_matching',
          'files_matching(
            pattern: "*.zip",
          )',
          'files_matching(
            pattern: "*.zip",
            directory: "./assets"
          )'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
