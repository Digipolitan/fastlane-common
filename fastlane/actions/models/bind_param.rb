module Fastlane
  module Actions

    # Class represents a parameter link between lane_context, env_var and value
    class BindParam

      attr_reader :name # The name of the field
      attr_reader :lane_context # The lane context of the field
      attr_reader :env_var # The environment variable of the field
      attr_reader :default_value # The default_value of the field
      attr_reader :optional # The field is require or optional

      def initialize(name, lane_context = nil, env_var = nil, default_value = nil, optional = true)
        @name = name
        @lane_context = lane_context
        @env_var = env_var
        @default_value = default_value
        @optional = optional
      end

      def value()
        if self.lane_context != nil
          if value = Actions.lane_context[self.lane_context]
            return value
          end
        end
        if self.env_var != nil
          if value = ENV[self.env_var]
            return value
          end
        end
        return @default_value
      end

      def value=(v)
        if self.env_var != nil
          ENV[self.env_var] = v
        end
        if self.lane_context != nil
          Actions.lane_context[self.lane_context] = v
        end
        @default_value = v
      end
    end

    class BindParamBuilder

      def initialize(name)
        @name = name
        @lane_context = nil
        @env_var = nil
        @default_value = nil
        @optional = true
      end

      def lane_context(lane_context)
        @lane_context = lane_context
        return self
      end

      def lane_context(lane_context)
        @lane_context = lane_context
        return self
      end

      def env_var(env_var)
        @env_var = env_var
        return self
      end

      def default_value(default_value)
        @default_value = default_value
        return self
      end

      def required()
        @optional = false
        return self
      end

      def ci_required()
        if ENV["CI"] != nil
          @optional = false
        end
        return self
      end

      def build()
        return BindParam.new(@name, @lane_context, @env_var, @default_value, @optional)
      end
    end
  end
end
