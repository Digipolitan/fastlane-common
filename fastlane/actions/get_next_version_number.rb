module Fastlane
  module Actions
    module SharedValues
      NEXT_VERSION_NUMBER = :NEXT_VERSION_NUMBER
    end

    class GetNextVersionNumberAction < Action
      def self.run(params)
        version = params[:version_number]
        bump_type = params[:bump_type]
        version_arr = version.split(".").map(&:to_i)
        arr_length = version_arr.length
        if arr_length > 0
          fill_zero_from = 1
          if bump_type == "major"
            version_arr[0] = version_arr[0] + 1
          elsif arr_length > 1
            fill_zero_from = 2
            if bump_type == "minor"
              version_arr[1] = version_arr[1] + 1
            elsif arr_length > 2
              fill_zero_from = 3
              version_arr[2] = version_arr[2] + 1
            else
              UI.user_error! "Cannot update more than the minor version because your version '#{version}' doesn't have 'patch' field"
            end
          else
            UI.user_error! "Cannot update more than the major version because your version '#{version}' doesn't have 'minor' or 'patch' field"
          end
          i = fill_zero_from
          while i < arr_length do
            version_arr[i] = 0
            i += 1
          end
        else
          UI.user_error! "The project version is invalid '#{version}' cannot split '.'"
        end
        res = version_arr.join(".")
        Actions.lane_context[SharedValues::NEXT_VERSION_NUMBER] = res
        return res
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Retrieves the next version number of a given version"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version_number,
                                       description: "The current version to upgrade",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :bump_type,
                                       description: "The bump type such as patch, minor or major",
                                       optional: false,
                                       verify_block: proc do |value|
                                         if value != "patch" && value != "minor" && value != "major"
                                          UI.user_error! "Wrong bump_type '#{value}', only 'patch', 'minor', 'major' are available."
                                        end
                                      end)

        ]
      end

      def self.output
        [
          ['NEXT_VERSION_NUMBER', 'The next version number']
        ]
      end

      def self.return_value
        "The next version number"
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
          'get_next_version_number(
            version_number: "1.0.5",
            bump_type: "minor"
          )',
          'get_next_version_number(
            version_number: "3",
            bump_type: "major"
          )',
          'get_next_version_number(
            version_number: "3.1",
            bump_type: "minor"
          )',
          'get_next_version_number(
            version_number: "1.1.2",
            bump_type: "patch"
          )'
        ]
      end
    end
  end
end
