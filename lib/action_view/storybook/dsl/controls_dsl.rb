# frozen_string_literal: true

module ActionView
  module Storybook
    module Dsl
      class ControlsDsl
        attr_reader :controls

        def initialize(story_config)
          @story_config = story_config
          @controls = []
        end

        def text(param, value, name: nil)
          controls << Controls::TextConfig.new(param, value, name: name)
        end

        def boolean(param, value, name: nil)
          controls << Controls::BooleanConfig.new(param, value, name: name)
        end

        def number(param, value, name: nil, min: nil, max: nil, step: nil)
          controls << Controls::NumberConfig.new(:number, param, value, name: name, min: min, max: max, step: step)
        end

        def range(param, value, name: nil, min: nil, max: nil, step: nil)
          controls << Controls::NumberConfig.new(:range, param, value, name: name, min: min, max: max, step: step)
        end

        def color(param, value, name: nil, preset_colors: nil)
          controls << Controls::ColorConfig.new(param, value, name: name, preset_colors: preset_colors)
        end

        def object(param, value, name: nil)
          controls << Controls::ObjectConfig.new(param, value, name: name)
        end

        def select(param, options, value, name: nil)
          controls << Controls::OptionsConfig.new(:select, param, options, value, name: name)
        end

        def multi_select(param, options, value, name: nil)
          controls << Controls::OptionsConfig.new(:'multi-select', param, options, value, name: name)
        end

        def radio(param, options, value, name: nil)
          controls << Controls::OptionsConfig.new(:radio, param, options, value, name: name)
        end

        def inline_radio(param, options, value, name: nil)
          controls << Controls::OptionsConfig.new(:'inline-radio', param, options, value, name: name)
        end

        def check(param, options, value, name: nil)
          controls << Controls::OptionsConfig.new(:check, param, options, value, name: name)
        end

        def inline_check(param, options, value, name: nil)
          controls << Controls::OptionsConfig.new(:'inline-check', param, options, value, name: name)
        end

        def array(param, value, separator = ",", name: nil)
          controls << Controls::ArrayConfig.new(param, value, separator, name: name)
        end

        def date(param, value, name: nil)
          controls << Controls::DateConfig.new(param, value, name: name)
        end

        def respond_to_missing?(_method, *)
          true
        end

        def method_missing(method, *args)
          value = args.first
          control_method = case value
                           when Date
                             :date
                           when Array
                             :array
                           when Hash
                             :object
                           when Numeric
                             :number
                           when TrueClass, FalseClass
                             :boolean
                           when String
                             :text
                           end
          if control_method
            send(control_method, method, *args)
          else
            super
          end
        end

        Controls = ActionView::Storybook::Controls
      end
    end
  end
end
