module Fastlane
  module Actions
    module SharedValues
      HEROKU_USER_NAME = :HEROKU_USER_NAME
      HEROKU_USER_TOKEN = :HEROKU_USER_TOKEN
    end

    class HerokuLoginAction < Action

      def self.get_user()
        begin
          return {
            :name => Actions.sh("heroku whoami", log: false).chomp(),
            :token => Actions.sh("heroku auth:token", log: false).chomp()
          }
        rescue StandardError
          return nil
        end
      end

      def self.login(email, password)
        UI.message "Connecting #{email} to Heroku..."
        file_name = ".heroku_login_expect.tmp"
        Actions.sh("rm -f #{file_name}", log: false)
        Actions.sh("echo '#!/usr/bin/expect' >> #{file_name}", log: false)
        Actions.sh("echo 'spawn heroku login' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Email:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{email}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect \"Password:\"' >> #{file_name}", log: false)
        Actions.sh("echo 'send \"#{password}\r\"' >> #{file_name}", log: false)
        Actions.sh("echo 'expect eof' >> #{file_name}", log: false)
        Actions.sh("expect -f #{file_name}", log: false)
        Actions.sh("rm -f #{file_name}", log: false)
      end

      def self.run(params)
        email = params[:email]
        password = params[:password]
        begin
          Actions.sh("heroku --version", log: false)
        rescue StandardError
          UI.user_error! "heroku command not found, install URL : https://devcenter.heroku.com/articles/heroku-cli"
        end
        begin
          Actions.sh("expect -v", log: false)
        rescue StandardError
          UI.user_error! "expect command not found"
        end
        user = self.get_user()
        if user == nil || user[:name] != email
          if user != nil
            user_name = user[:name]
            UI.message "Disconnecting user '#{user_name}' from Heroku..."
            Actions.sh("heroku logout", log: false)
            if self.get_user() != nil
              UI.user_error! "Error during logout"
            end
          end
          self.login(email, password)
          user = self.get_user()
          if user == nil
            UI.user_error! "Invalid credentials or network error"
          else
            UI.success "Successfully connected #{email} to Heroku"
          end
        end
        Actions.lane_context[SharedValues::HEROKU_USER_NAME] = user[:name]
        Actions.lane_context[SharedValues::HEROKU_USER_TOKEN] = user[:token]
        return user
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Connects or retrieves the user on Heroku"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :email,
                                       env_name: "HEROKU_LOGIN_EMAIL",
                                       description: "The user name on Heroku",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: "HEROKU_LOGIN_PASSWORD",
                                       description: "The user password on Heroku",
                                       optional: false)
        ]
      end

      def self.output
        [
          ['HEROKU_USER_NAME', 'The user name'],
          ['HEROKU_USER_TOKEN', 'The user token']
        ]
      end

      def self.return_value
        "A Heroku user with his name and his token"
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
