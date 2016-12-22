module Fastlane
  module Actions
    module SharedValues
    end

    class UserValidationAction < Action
      def self.run(params)
        fields = params[:fields]
        dialog = ""
        fields.each { |field|
          name = field[:name]
          if field[:value] == nil && field[:optional] == false
            field[:value] = self.get_required_value(name)
          end
          value = field[:value]
          dialog += "* #{name} : '#{value}'\n"
        }
        dialog += params[:message] ? params[:message] : "Would you like to update these informations ?"
        if UI.confirm(dialog)
          fields.each { |field|
            name = field[:name]
            value = field[:value]
            if value == nil || UI.confirm("Would you like to change #{name} '#{value}' ?")
              new_value = nil
              if field[:optional] != false
                new_value = self.get_optional_value(name)
              else
                new_value = self.get_required_value(name)
              end
              field[:value] = new_value
            end
          }
        end
        fields.each { |field|
          if field[:lane_context] != nil
            Actions.lane_context[field[:lane_context]] = field[:value]
          end
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
          FastlaneCore::ConfigItem.new(key: :fields,
                                       optional: false,
                                       is_string: false),
          FastlaneCore::ConfigItem.new(key: :message,
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
            fields: [{
              name: "Firstname",
              value: "Jean",
              lane_context: :TEST_FIRSTNAME
            }, {
              name: "Lastname",
              lane_context: :TEST_LASTNAME,
              optional: false
            }]
          )',
          'user_validation(
            fields: [{
              name: "Firstname",
              value: "Jean",
              lane_context: :TEST_FIRSTNAME
            }],
            message: "Would you like to update this information ?"
          )'
        ]
    end
  end
end
