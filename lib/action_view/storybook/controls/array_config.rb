# frozen_string_literal: true

module ActionView
  module Storybook
    module Controls
      class ArrayConfig < ControlConfig
        attr_reader :separator

        validates :separator, presence: true

        def initialize(param, value, separator = ",", name: nil)
          super(param, value, name: name)
          @separator = separator
        end

        def type
          :array
        end

        def value_from_param(param)
          if param.is_a?(String)
            param.split(separator)
          else
            super(param)
          end
        end

        private

        def csf_control_params
          super.merge(separator: separator)
        end
      end
    end
  end
end
