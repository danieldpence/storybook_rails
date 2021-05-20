# frozen_string_literal: true

require "active_support/dependencies/autoload"

module ActionView
  module Storybook
    module Dsl
      extend ActiveSupport::Autoload

      autoload :StoryDsl
      autoload :ControlsDsl
    end
  end
end
