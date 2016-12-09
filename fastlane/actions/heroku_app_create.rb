module Fastlane
  module Actions
    module SharedValues
      HEROKU_APP_URL = :HEROKU_APP_URL
      HEROKU_APP_GIT = :HEROKU_APP_GIT
    end

    class HerokuAppCreateAction < Action

      def self.exists(name, organization)
        cmd = ["heroku apps"]
        if organization != nil
          cmd << "--org #{organization}"
        end
        cmd << "| grep -w '#{name}'"
        begin
         Actions.sh(cmd.join(" "))
         return true
        rescue StandardError
         return false
        end
      end

      def self.run(params)
        name = params[:name]
        if self.exists(name, params[:organization]) == false
          self.create(name, params[:organization], params[:region])
        end
        Actions.lane_context[SharedValues::HEROKU_APP_URL] = "https://#{name}.herokuapp.com"
        Actions.lane_context[SharedValues::HEROKU_APP_GIT] = "https://git.heroku.com/#{name}.git"
      end

      def self.create(name, organization, region)
        cmd = ["heroku create #{name}"]
        if organization != nil
          cmd << "--org #{organization}"
        end
        if region != nil
          cmd << "--region #{region}"
        end
        Actions.sh(cmd.join(" "))
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Create a new app on Heroku"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :name,
                                       env_name: "HEROKU_APP_NAME",
                                       description: "The Heroku app name",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :organization,
                                       env_name: "HEROKU_APP_ORGANIZATION",
                                       description: "The organization owner",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :region,
                                       env_name: "HEROKU_APP_REGION",
                                       description: "The distribution region",
                                       default_value: "eu")
        ]
      end

      def self.output
        [
          ['HEROKU_APP_URL', 'The Heroku app URL'],
          ['HEROKU_APP_GIT', 'The Heroku git']
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
