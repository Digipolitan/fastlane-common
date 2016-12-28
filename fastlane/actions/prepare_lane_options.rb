require_relative 'models/bind_param'

module Fastlane
  module Actions
    module SharedValues
    end

    class PrepareLaneOptionsAction < Action
      def self.run(params)
        options = params[:options]
        bind_params = params[:bind_params]
        bind_params.each { |param|
          name = param.name
          if options[name] == nil
            if value = param.value
              options[name] = value
            elsif param.optional == false
              error_msg = "Missing required lane option '#{name}'"
              if env_var = param.env_var
                error_msg << " or environment variable '#{env_var}'"
              end
              if lane_context = param.lane_context
                error_msg << " or lane context '#{lane_context}'"
              end
              UI.user_error! error_msg
            end
          end
        }
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
          FastlaneCore::ConfigItem.new(key: :bind_params,
                                       description: "Array of BindParam",
                                       is_string: false,
                                       optional: false)
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
            bind_params: [
              Actions::BindParamBuilder.new(:product_name).env_var("PRODUCT_NAME").build(),
              Actions::BindParamBuilder.new(:github_release_link).lane_context(SharedValues::SET_GITHUB_RELEASE_HTML_LINK)).build()
            ]
          )',
          'prepare_lane_options(
            options: lane_options,
            bind_params: [
              Actions::BindParamBuilder.new(:product_name).env_var("PRODUCT_NAME").required().build(),
              Actions::BindParamBuilder.new(:changelog).env_var("CHANGELOG_CONTENT").default_value("Empty changelog").build()
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
