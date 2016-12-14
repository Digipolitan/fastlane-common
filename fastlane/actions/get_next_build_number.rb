module Fastlane
  module Actions
    module SharedValues
      NEXT_BUILD_NUMBER = :NEXT_BUILD_NUMBER
    end

    class GetNextBuildNumberAction < Action
      def self.run(params)
        build = params[:build_number]
        res = (build.to_i + 1).to_s
        Actions.lane_context[SharedValues::NEXT_BUILD_NUMBER] = res
        return res
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Retrieves the next build number"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :build_number,
                                       description: "The current build number",
                                       optional: false)
        ]
      end

      def self.output
        [
          ['NEXT_BUILD_NUMBER', 'The next build numner']
        ]
      end

      def self.return_value
        "The next build number"
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
          'get_next_build_number(
            build_number: "10"
          )'
        ]
      end
    end
  end
end
