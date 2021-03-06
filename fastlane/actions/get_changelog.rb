module Fastlane
  module Actions
    module SharedValues
    end

    class GetChangelogAction < Action
      def self.run(params)
        changelog_path = params[:file_path]
        if File.exist?(changelog_path)
          if content = File.read(changelog_path)
            delimiter = params[:delimiter]
            length = content.length
            if start_index = content.index(delimiter)
              start_index += delimiter.length
              end_index = content.index(delimiter, start_index)
              if end_index == nil
                end_index = length
              end
              if res = content[start_index, end_index - start_index]
                return self.stripVersionHeader(res)
              end
            end
          end
        end
        return nil
      end

      def self.stripVersionHeader(changelog)
        if start_index = changelog.index("##")
          end_index = changelog.index("\n", start_index)
          res = changelog[0, start_index]
          if end_index != nil
            end_index += 1
            res += changelog[end_index, changelog.length - end_index]
          end
          changelog = res
        end
        return changelog.strip()
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
                                       env_name: "CHANGELOG_FILE_PATH",
                                       description: "The file path to the changelog file",
                                       default_value: "CHANGELOG.md"),
          FastlaneCore::ConfigItem.new(key: :delimiter,
                                       env_name: "CHANGELOG_DELIMITER",
                                       description: "The changelog delimiter",
                                       default_value: "---")
        ]
      end

      def self.return_value
        "Returns the last changelog content"
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
