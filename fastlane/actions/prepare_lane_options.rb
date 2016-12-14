module Fastlane
  module Actions
    module SharedValues
    end

    class PrepareLaneOptionsAction < Action
      def self.run(params)
        mapping = params[:mapping]
        required_keys = params[:required_keys]
        options = params[:options]
        if mapping != nil
          mapping.each { |key, mapping_info|
            if options[key] == nil
              env_var = mapping_info[:env_var]
              lane_context = mapping_info[:lane_context]
              if env_var != nil && ENV[env_var] != nil
                options[key] = ENV[env_var]
              elsif lane_context != nil && Actions.lane_context[lane_context] != nil
                  options[key] = Actions.lane_context[lane_context]
              elsif mapping_info[:default_value] != nil
                options[key] = mapping_info[:default_value]
              end
            end
          }
        end
        if required_keys != nil
          required_keys.each { |key|
            if options[key] == nil
              error_msg = "Missing required lane option '#{key}'"
              if mapping != nil
                if mapping_info = mapping[key]
                  if env_var = mapping_info[:env_var]
                    error_msg << " or environment variable '#{env_var}'"
                  end
                  if lane_context = mapping_info[:lane_context]
                    error_msg << " or lane context '#{lane_context}'"
                  end
                end
              end
              UI.user_error! error_msg
            end
          }
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Fill env_var, lane_context or default_value with key inside the input lane options and ckeck required keys"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :options,
                                       description: "inout lane Hash options, will be fill by the mapping",
                                       is_string: false,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :mapping,
                                       description: "Hash containing key => {env_var:?, default_value:?}, match the key with an environment variable or a default value",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :required_keys,
                                       description: "Array of required key for the options Hash",
                                       is_string: false,
                                       optional: true)
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
          'prepare_lane_options(
            options: lane_options,
            mapping: {
              :product_name => {
                :env_var => "DG_PRODUCT_NAME",
              },
              :github_release_link => {
                :lane_context => SharedValues::SET_GITHUB_RELEASE_HTML_LINK
              }
            }
          )',
          'prepare_lane_options(
            options: lane_options,
            mapping: {
              :product_name => {
                :env_var => "DG_PRODUCT_NAME"
              },
              :changelog => {
                :env_var => "DG_CHANGELOG_CONTENT",
                :default_value => "Empty changelog"
              },
            },
            required_keys: [
              :product_name
            ]
          )'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
