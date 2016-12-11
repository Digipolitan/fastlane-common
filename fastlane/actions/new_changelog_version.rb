module Fastlane
  module Actions
    module SharedValues
    end

    class NewChangelogVersionAction < Action
      def self.run(params)
        file_path = params[:file_path]
        product_name = params[:product_name]
        data = nil
        if File.exists?(file_path)
          data = File.read(file_path)
        end
        if data == nil || data.length == 0
          data = "#Change Log\n\nAll notable changes to this project will be documented in this file.\n`#{product_name}` adheres to [Semantic Versioning](http://semver.org/).\n\n"
        end
        delimiter = params[:delimiter]
        changelog = "#{delimiter}\n\n## "
        version = params[:version]
        url = params[:url]
        content = params[:content]
        if url != nil
          changelog << "[#{version}](#{url})"
        else
          changelog << "#{version}"
        end
        changelog << "\n\n#{content}\n"
        if i = data.index(delimiter)
          data.insert(i, changelog)
        else
          data << changelog
        end
        File.open(file_path, "w") { |file|
          file.puts(data)
        }
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Add a new version inside the changelog file"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "DG_RELEASE_VERSION",
                                       description: "The new changelog version",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :product_name,
                                       env_name: "DG_PRODUCT_NAME",
                                       description: "The deployment name",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "DG_RELEASE_URL",
                                       description: "The distant releasse url",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :content,
                                       env_name: "DG_CHANGELOG_CONTENT",
                                       description: "The changelog content",
                                       optional: false),
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

      def self.authors
        ["bbriatte"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'new_change_log_version(
            verion: "1.0.0",
            product_name: "my_app"
          )',
          'new_change_log_version(
            version: "2.1.4",
            product_name: "my_app",
            url: "https://download.my_app.com/release/v2.1.4",
            content: "New feature available !",
            delimiter: "***"
          )'
        ]
      end

      def self.category
        :source_control
      end
    end
  end
end
