module Fastlane
  module Actions
    module SharedValues
      GIT_VERSION_TAG = :GIT_VERSION_TAG
      GIT_BUILD_TAG = :GIT_BUILD_TAG
    end

    class GitVersionAvailabilityAction < Action
      def self.run(params)
        prefix_versiontag = params[:prefix_versiontag]
        version_number = params[:version_number]
        build_number = params[:build_number]
        while other_action.git_tag_exists(tag: "#{prefix_versiontag}#{version_number}") do
          version_number = self.select_new_version_number(version_number)
          build_number = "1"
        end
        while other_action.git_tag_exists(tag: "#{prefix_versiontag}#{version_number}##{build_number}") do
          build_number = self.select_new_build_number(build_number)
        end
        UI.success "The version '#{version_number}' build ##{build_number} is available"
        lane_context[SharedValues::NEXT_VERSION_NUMBER] = version_number
        lane_context[SharedValues::NEXT_BUILD_NUMBER] = build_number
        lane_context[SharedValues::GIT_VERSION_TAG] = "#{prefix_versiontag}#{version_number}"
        lane_context[SharedValues::GIT_BUILD_TAG] = "#{prefix_versiontag}#{version_number}##{build_number}"
      end

      def self.select_new_version_number(version_number)
        UI.error "You must update your version '#{version_number}'"
        bump_type = UI.select("Select version bump type: ", ["patch", "minor", "major"])
        return other_action.get_next_version_number(
          version_number: version_number,
          bump_type: bump_type
        )
      end

      def self.select_new_build_number(build_number)
        UI.error "You must update your build number ##{build_number}"
        user_build_number = UI.input("Set the build number [press enter to auto-increment] ")
        if user_build_number.length == 0
          return other_action.get_next_build_number(build_number: build_number)
        end
        Actions.lane_context[SharedValues::NEXT_BUILD_NUMBER] = user_build_number
        return user_build_number
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Retrieves the next git version / build pair availability "
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version_number,
                                       description: "The current version number",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :build_number,
                                       description: "The current build number",
                                       default_value: "1"),
          FastlaneCore::ConfigItem.new(key: :prefix_versiontag,
                                       description: "The prefix tag for each version",
                                       is_string: false,
                                       optional: true)
        ]
      end

      def self.output
        [
          ['NEXT_VERSION_NUMBER', 'The next version number'],
          ['NEXT_BUILD_NUMBER', 'The next build number'],
          ['GIT_VERSION_TAG', 'The git version tag'],
          ['GIT_BUILD_TAG', 'The git version tag including the build number']
        ]
      end

      def self.authors
        ["bbriatte"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
