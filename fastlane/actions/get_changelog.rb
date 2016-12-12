module Fastlane
  module Actions
    module SharedValues
    end

    class GetChangelogAction < Action
      def self.run(params)
        if content = File.read(params[:file_path])
          delimiter = params[:delimiter]
          length = content.length
          if start_index = content.index(delimiter)
            start_index += delimiter.length
            end_index = content.index(delimiter, start_index)
            if end_index == nil
              end_index = length
            end
            if res = content[start_index, end_index - start_index]
              return res.strip()
            end
          end
        end
        return nil
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Retrieves the last changelog content from the CHANGELOG file"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :file_path,
                                       env_name: "DG_CHANGELOG_FILE_PATH",
                                       description: "The file path to the changelog file",
                                       default_value: "CHANGELOG.md"),
          FastlaneCore::ConfigItem.new(key: :delimiter,
                                       env_name: "DG_CHANGELOG_DELIMITER",
                                       description: "The changelog delimiter",
                                       default_value: "---")
        ]
      end

      def self.return_value
        "All the last changelog content"
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
          'get_changelog',
          'get_changelog(
            delimiter: "***"
          )'
        ]
      end
    end
  end
end
