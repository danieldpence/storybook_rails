# frozen_string_literal: true

module ActionView
  module Storybook
    module Controls
      class ControlConfig
        include ActiveModel::Validations

        attr_reader :param, :value, :name

        validates :param, presence: true

        def initialize(param, value, name: nil)
          @param = param
          @value = value
          @name = name || param.to_s.humanize.titlecase
        end

        def to_csf_params
          {
            args: { param => csf_value },
            argTypes: { param => { control: csf_control_params, name: name } }
          }
        end

        def value_from_param(param)
          param
        end

        private

        # provide extension points for subclasses to vary the value
        def csf_value
          value
        end

        def csf_control_params
          { type: type }
        end
      end
    end
  end
end
