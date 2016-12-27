require_relative '../tools/bind_param'

module Fastlane
  module Actions
    module SharedValues
    end

    class UserValidationAction < Action
      def self.run(params)
        bind_params = params[:bind_params]
        dialog = ""
        bind_params.each { |param|
          name = param.name
          if param.value == nil && param.optional == false
            param.value = self.get_required_value(name)
          end
          dialog += "* #{name} : '#{param.value}'\n"
        }
        dialog += params[:message] ? params[:message] : "Would you like to update these informations ?"
        if UI.confirm(dialog)
          bind_params.each { |param|
            name = param.name
            value = param.value
            if value == nil || UI.confirm("Would you like to update #{param.name} '#{value}' ?")
              if param.optional != false
                param.value = self.get_optional_value(name)
              else
                param.value = self.get_required_value(name)
              end
            end
          }
        end
        bind_params.each { |param|
          param.value = param.value # update lane_context // env_var and default_value
        }
      end

      def self.get_optional_value(name)
        new_value = UI.input("New #{name} ? [Press enter to ignore]")
        if new_value.length() > 0
          return nil
        end
        return new_value
      end

      def self.get_required_value(name)
        new_value = nil
        loop do
          new_value = UI.input("New #{name} ?")
          break if new_value.length > 0
        end
        return new_value
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Ask the user to fill informations"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :bind_params,
                                       description: "Array of BindParam",
                                       optional: false,
                                       is_string: false),
          FastlaneCore::ConfigItem.new(key: :message,
                                       description: "The user prompt message",
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
          'user_validation(
            bind_params: [
              Actions::BindParam.optional("Firstname", :TEST_FIRSTNAME, nil, "Jean"),
              Actions::BindParam.required("Lastname", :TEST_LASTNAME)
            ]
          )',
          'user_validation(
            bind_params: [
              Actions::BindParam.optional("Firstname", nil, "ENV_FIRSTNAME", "Jean")
            ],
            message: "Would you like to update this information ?"
          )'
        ]
      end
    end
  end
end
